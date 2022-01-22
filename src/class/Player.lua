Player = Class {}

function Player:init(tempX, tempY, tempT)
	-- Position: (variable)
	self.x = tempX
	self.y = tempY

	-- Starting Position: (constant)
	self.xStart = tempX
	self.yStart = tempY

	-- Speed:
	self.xSpeed = 0
	self.ySpeed = 0

	-- Speed Change: (throttle 0 - 1; variable) (speed; constant (max speed change))
	self.throttle = 0.5
	self.speed = starshipTypes[tempT].speed

	-- Landings:
	self.impacttolerance = starshipTypes[tempT].impacttolerance
	self.landingspeed = 0

	-- Mass:
	self.m = starshipTypes[tempT].mass

	-- Rotation:
	self.angle = calc.pi/2

	-- Status:
	self.exploding = false

	--TEXTURE HERE?
end



-- FUNCTIONS

function Player:throttleControls()
	local change = 0.01
	local max, min = 1, 0
	-- Throttle up
	if love.keyboard.isDown(controls.flight.throttle.up) then
		self.throttle = self.throttle + change
	end
	-- Throttle down
	if love.keyboard.isDown(controls.flight.throttle.down) then
		self.throttle = self.throttle - change
	end

	-- Throttle max
	if love.keyboard.isDown(controls.flight.throttle.full) then
		self.throttle = max
	end
	-- Throttle None
	if love.keyboard.isDown(controls.flight.throttle.none) then
		self.throttle = min
	end

	-- Throttle Limiter:
	if self.throttle < 0 then
		self.throttle = 0
	elseif self.throttle > 1 then
		self.throttle = 1
	end
end

function Player:reset()
	self.x = self.xStart
	self.y = self.yStart

	self.xSpeed = 0
	self.ySpeed = 0
end

function Player:flightControls()
	-- Anti-clipping feature 
	local closestPla = calc.closestObj(player)


	-- Movement:
	local speedChange = self.speed * self.throttle
	
	-- Directional Thrust:
	if love.keyboard.isDown(controls.flight.thrust.up)then
		if (calc.distance(closestPla.x, closestPla.y, self.x, self.y) > calc.distance(closestPla.x, closestPla.y, self.x, self.y-10) and self:isLanded()) then 
			debug("Flying into a planet!")
		else
			self.ySpeed = self.ySpeed - speedChange
			debug("Player control: up")
		end
	end

	if love.keyboard.isDown(controls.flight.thrust.down) then
		if (calc.distance(closestPla.x, closestPla.y, self.x, self.y) > calc.distance(closestPla.x, closestPla.y, self.x, self.y+10) and self:isLanded()) then 
			debug("Flying into a planet!")
		else
			self.ySpeed = self.ySpeed + speedChange
			debug("Player control: down")
		end
	end

	if love.keyboard.isDown(controls.flight.thrust.left) then
		if (calc.distance(closestPla.x, closestPla.y, self.x, self.y) > calc.distance(closestPla.x, closestPla.y, self.x-10, self.y) and self:isLanded()) then 
			debug("Flying into a planet!")
		else
			self.xSpeed = self.xSpeed - speedChange
			debug("Player control: left")
		end
	end

	if love.keyboard.isDown(controls.flight.thrust.right) then
		if (calc.distance(closestPla.x, closestPla.y, self.x, self.y) > calc.distance(closestPla.x, closestPla.y, self.x+10, self.y) and self:isLanded()) then 
			debug("Flying into a planet!")
		else
			self.xSpeed = self.xSpeed + speedChange
			debug("Player control: right")
		end
	end


	-- Main Engine controls:
	if love.keyboard.isDown(controls.flight.thrust.engine) then 
		if (calc.distance(closestPla.x, closestPla.y, self.x, self.y) > calc.distance(closestPla.x, closestPla.y, self.x+self.xSpeed + math.cos(self.angle) * speedChange*2, self.y+self.ySpeed - math.sin(self.angle) * speedChange*2) and self:isLanded()) then    --Holy moly this is long
			debug("Flying into a planet!")
		else
			self.xSpeed = self.xSpeed + math.cos(self.angle) * speedChange*2 
			debug("Ship thrusters X: " .. math.cos(self.angle) .. " " .. math.sin(self.angle) .. " " .. self.angle)
			self.ySpeed = self.ySpeed - math.sin(self.angle) * speedChange*2
		end 
	end
	if love.keyboard.isDown(controls.flight.thrust.rotleft) then 
		self.angle = self.angle + 1/love.timer.getFPS()
	end
	if love.keyboard.isDown(controls.flight.thrust.rotright) then 
		self.angle = self.angle - 1/love.timer.getFPS()
	end


	-- Reset:
	if love.keyboard.isDown(controls.flight.reset) then
		self:reset()
		debug("Player control: reset")
	end
end

function Player:getSpeed()
	local x, y = self.xSpeed, self.ySpeed
	if x < 0 then
		x = -x
	end
	if y < 0 then
		y = -y
	end
	return x+y
end

function Player:hasCrashed() --Testing function, see if a player is inside a planet
	--debug(self.landingspeed)
	if self.landingspeed > self.impacttolerance and not self.exploding then 
			-- Add explosion effect?
		table.insert(effects, FX("flash", self.x, self.y, self))
		self.exploding = true
		return
	end 
end

function Player:isLanded()
    local landed = false
    for i=1, #planet do
        local pla = planet[i]
        if calc.distance(self.x, self.y, pla.x, pla.y) <= pla.r then
            landed = true
        end
    end
    -- Save Landing Speed:
    if landed then
        self.landingspeed = self:getSpeed()
        debug("Landing speed: "..self.landingspeed)
    end
	self:hasCrashed()
    return landed
end

function Player:gravity()
	if self:isLanded() then
		-- Player is landed:
		self.xSpeed, self.ySpeed = 0, 0
	end
end

function Player:updatePosition()
	self.x = self.x + self.xSpeed
	self.y = self.y + self.ySpeed
end



-- MAIN

function Player:update(dt)
	--debug(self.warpspeed)
	
	if self.angle > calc.pi*2 then 
		self.angle = 0
	elseif self.angle < 0 then 
		self.angle = calc.pi*2
	end
	if not self.exploding then 
		self:gravity()
		self:flightControls()
		self:updatePosition()
	end 
end

function Player:draw()
	local x, y = self.x, self.y
	local dist = 10
	-- Funky arrow type form
	local vertices = {
		-- Top
		x, y-dist,
		-- Left Bottom
		x-dist, y+dist,
		-- Middle Down
		x, y+dist/2,
		-- Right Bottom
		x+dist, y+dist
	}
	if not self.exploding then 
		love.graphics.setColor(0.5, 0.5, 0.7)
		love.graphics.polygon("fill", vertices)

		love.graphics.setColor(1, 0, 0)
		love.graphics.circle("fill", x, y, 5, 20)

		-- Directional Circle (temporary until actual rotatable ship texture is made)
		love.graphics.circle("fill", x+dist*(1/zoomlevel*2)*math.cos(self.angle), y-dist*(1/zoomlevel*2)*math.sin(self.angle), 1/zoomlevel*2)
	end 
end