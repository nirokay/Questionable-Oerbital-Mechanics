Player = Class {}

function Player:init(tempX, tempY)
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
	self.speed = 0.05

	-- Time Warping:
	self.warpspeed = 1
	self.warpLimit = 10
	-- Cooldown Between Clicking:
	self.warpCoolDown = 30
	self.coolDown = 0

	-- Landings:
	self.impacttolerance = 0.5
	self.landingspeed = 0

	-- Mass:
	self.m = 10

	-- Rotation:
	self.angle = calc.pi/2
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
	-- Movement:
	local speedChange = self.speed * self.throttle

	-- Directional Thrust:
	if love.keyboard.isDown(controls.flight.thrust.up)then
		self.ySpeed = self.ySpeed - speedChange
		debug("Player control: up")
	end

	if love.keyboard.isDown(controls.flight.thrust.down) then
		self.ySpeed = self.ySpeed + speedChange
		debug("Player control: down")
	end

	if love.keyboard.isDown(controls.flight.thrust.left) then
		self.xSpeed = self.xSpeed - speedChange
		debug("Player control: left")
	end

	if love.keyboard.isDown(controls.flight.thrust.right) then
		self.xSpeed = self.xSpeed + speedChange
		debug("Player control: right")
	end


	-- Main Engine controls:
	if love.keyboard.isDown(controls.flight.thrust.engine) then 
		self.xSpeed = self.xSpeed + math.cos(self.angle) * speedChange 
		debug("Ship thrusters X: " .. math.cos(self.angle) .. " " .. math.sin(self.angle) .. " " .. self.angle)
		self.ySpeed = self.ySpeed - math.sin(self.angle) * speedChange
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
		--debug("Landing speed: "..self.landingspeed)
	end

	return landed
end

function Player:gravity()
	if self:isLanded() then
		-- Player is landed:
		self.xSpeed, self.ySpeed = 0, 0
	end
end

function Player:timewarp()
	local step = 1
	-- Time Warp Limits:
	local min = 1
	local max = self.warpLimit

	-- Decrease Warp
	if love.keyboard.isDown(controls.flight.warp.down) and self.coolDown <= 0 then
		self.warpspeed = self.warpspeed - step
		self.coolDown = self.warpCoolDown
	end
	-- Increase Warp
	if love.keyboard.isDown(controls.flight.warp.up) and self.coolDown <= 0 then
		self.warpspeed = self.warpspeed + step
		self.coolDown = self.warpCoolDown
	end
	-- Reset Warp
	if love.keyboard.isDown(controls.flight.warp.reset) then
		self.warpspeed = min
	end

	-- Value Correction
	if self.warpspeed < min then
		self.warpspeed = min
	elseif self.warpspeed > max then 
		self.warpspeed = max
	end

	return self.warpspeed
end

function Player:updatePosition()
	self.x = self.x + self.xSpeed
	self.y = self.y + self.ySpeed
end



-- MAIN

function Player:update(dt)
	--debug(self.warpspeed)
	self:timewarp()
	for i=1, self.warpspeed do
		self:gravity()
		self:flightControls()
		self:updatePosition()
	end
	self:throttleControls()
	if self.angle > calc.pi*2 then 
		self.angle = 0
	elseif self.angle < 0 then 
		self.angle = calc.pi*2
	end
	self.coolDown = self.coolDown - 1
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
	love.graphics.setColor(0.5, 0.5, 0.7)
	love.graphics.polygon("fill", vertices)

	love.graphics.setColor(1, 0, 0)
	love.graphics.circle("fill", x, y, 5, 20)

	-- Directional Circle (temporary until actual rotatable ship texture is made)
	love.graphics.circle("fill", x+dist*math.cos(self.angle), y-dist*math.sin(self.angle), 3, 20)
end