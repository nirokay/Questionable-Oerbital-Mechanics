Player = Class {}

function Player:init(tempX, tempY, tempT)
	-- Position: (variable)
	self.x = tempX
	self.y = tempY

	-- Starting Position: (constant)
	self.xStart = tempX
	self.yStart = tempY

	self.orbitalX = 0
	self.orbitalY = 0

	-- Speed:
	self.xSpeed = 0
	self.ySpeed = 0

	-- Speed Change: (throttle 0 - 1; variable) (speed; constant (max speed change))
	self.throttle = 0.5
	self.speed = starshipTypes[tempT].speed

	-- Landings:
	self.impacttolerance = starshipTypes[tempT].impacttolerance
	self.landingspeed = 0
	self.landedOn = nil

	-- Mass:
	self.m = starshipTypes[tempT].mass

	-- Rotation:
	self.angle = calc.pi/2

	-- Status:
	self.exploding = false
	self.inRange = nil

	--TEXTURE HERE?
	self.texture = love.graphics.newImage(starshipTypes[tempT].texture)
	self.width = self.texture:getWidth()
	self.height = self.texture:getHeight()
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
	self.landingspeed = 0
	self.angle = calc.pi/2
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
			--debug("Flying into a planet!")
		else
			self.ySpeed = self.ySpeed - speedChange
		end
	end

	if love.keyboard.isDown(controls.flight.thrust.down) then
		if (calc.distance(closestPla.x, closestPla.y, self.x, self.y) > calc.distance(closestPla.x, closestPla.y, self.x, self.y+10) and self:isLanded()) then 
			--debug("Flying into a planet!")
		else
			self.ySpeed = self.ySpeed + speedChange
		end
	end

	if love.keyboard.isDown(controls.flight.thrust.left) then
		if (calc.distance(closestPla.x, closestPla.y, self.x, self.y) > calc.distance(closestPla.x, closestPla.y, self.x-10, self.y) and self:isLanded()) then 
			--debug("Flying into a planet!")
		else
			self.xSpeed = self.xSpeed - speedChange
		end
	end

	if love.keyboard.isDown(controls.flight.thrust.right) then
		if (calc.distance(closestPla.x, closestPla.y, self.x, self.y) > calc.distance(closestPla.x, closestPla.y, self.x+10, self.y) and self:isLanded()) then 
			--debug("Flying into a planet!")
		else
			self.xSpeed = self.xSpeed + speedChange
		end
	end


	-- Main Engine controls:
	if love.keyboard.isDown(controls.flight.thrust.engine) then 
		if (calc.distance(closestPla.x, closestPla.y, self.x, self.y) > calc.distance(closestPla.x, closestPla.y, self.x+self.xSpeed + math.cos(self.angle) * speedChange*2, self.y+self.ySpeed - math.sin(self.angle) * speedChange*2) and self:isLanded()) then    --Holy moly this is long
			debug("Flying into a planet!")
		else
			self.xSpeed = self.xSpeed + math.cos(self.angle) * speedChange*2 
			--debug("Ship thrusters X: " .. math.cos(self.angle) .. " " .. math.sin(self.angle) .. " " .. self.angle)
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
	end
end

function Player:getSpeed()		-- absolute speed
	return math.abs(self.xSpeed) + math.abs(self.ySpeed) + math.abs(self.orbitalY) + math.abs(self.orbitalX)
end

function Player:getSpeedTo(obj)		-- relative speed to an object
	return math.abs(self:getSpeed() - obj:getSpeed())
end

function Player:getOrbitHeight(obj) -- gets the height of the orbit (above surface)
	return calc.distance(self.x, self.y, obj.x, obj.y)-obj.r
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
    for i, p in ipairs(planet) do
        if self:getOrbitHeight(p) <= 1 then
            landed = true
			self.landedOn = p
			debug("Player touched down on: "..p.name)
        end
    end
    -- Save Landing Speed:
    if landed then
		local player = math.abs(self:getSpeed())
		local planet = math.abs(self.landedOn:getSpeed())

        self.landingspeed = math.abs(player-planet)
        debug("Landing speed: "..self.landingspeed)
    end
	self:hasCrashed()
    return landed
end

function Player:gravity()
	if self:isLanded() then
		-- Player is landed:
		local p = self.landedOn
		self.xSpeed, self.ySpeed = 0, 0
		
	end
	local p = calc.closestObj(player)
	if self:getOrbitHeight(p) < p.r and p.parent then 
		if self.inRange ~= p then 
			self.xSpeed = 0
			self.ySpeed = 0
			self.inRange = p 
		end 
		self.orbitalX = p.xSpeed + p.orbitalX 
		self.orbitalY = p.ySpeed + p.orbitalY 
		debug("Synced speed" .. self.orbitalX .. " " .. self.orbitalY .. " with " .. p.name)
	else 
		self.inRange = nil
		self.orbitalX = 0 
		self.orbitalY = 0
	end
end

function Player:updatePosition()
	self.x = self.x + self.xSpeed + self.orbitalX 
	self.y = self.y + self.ySpeed + self.orbitalY
end

function Player:drawTexture(x, y, r)
	-- Texture offset and size
	local t = {s = 50}

	-- Draw Texture
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.texture, self.x, self.y, -(self.angle-calc.pi/2), 1, 1, self.width/2, self.height/2)
	--debug("Angle: "..self.angle)
end



-- MAIN

function Player:update(dt)
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

	if not self.exploding then 
	self:drawTexture(x, y, calc.pi/2 - self.angle)
	end 


	if not self.exploding then 
		if calc.isDebug then
			-- Debugging Draw of actual Player Position
			love.graphics.setColor(1, 0, 0)
			love.graphics.circle("fill", x, y, 5, 20)
		end

		-- Directional Circle (temporary until actual rotatable ship texture is made)
		love.graphics.circle("fill", x+dist*(1/zoomlevel*2)*math.cos(self.angle), y-dist*(1/zoomlevel*2)*math.sin(self.angle), 1/zoomlevel*2)
	end 
end