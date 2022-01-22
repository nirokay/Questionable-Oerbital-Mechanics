Planet = Class {}

function Planet:init(tempX, tempY, tempR, tempM, tempXSpeed, tempYSpeed, tempName, tempC, tempP)
	-- Planet Position:
	self.x = tempX
	self.y = tempY

	-- Speed:
	self.xSpeed = 0
	self.ySpeed = 0

	-- Orbital speed:
	self.orbitalX = 0
	self.orbitalY = 0

	-- Speed Change: (throttle 0 - 1; variable) (speed; constant (max speed change))
	self.throttle = 0.5
	self.speed = 0.05

	-- Planet Radius and Mass:
	self.r = tempR
	self.m = tempM

	-- Planet Data:
	self.name = tempName
	self.colour = tempC

	-- Planet Family: 
	self.children = {}
	if (tempP ~= "star") then
		self.xSpeed = tempXSpeed
		self.ySpeed = tempYSpeed
		self.parent = planet[tempP]
		table.insert(planet[tempP].children, self)
	end 
end




-- FUNCTIONS

function Planet:getSpeed()
	return math.abs(self.xSpeed) + math.abs(self.ySpeed) + math.abs(self.orbitalY) + math.abs(self.orbitalX)
end

function Planet:updatePosition()
	self.x = self.x + self.xSpeed + self.orbitalX
	self.y = self.y + self.ySpeed + self.orbitalY
	--debug("Updating position of planet " .. self.name .. ": " .. self.x .. " " .. self.y)
end

function Planet:attract(dt)		--Planet doing the attracting, divided in two parts:	
	--Attracting children
	for i, child in ipairs(self.children) do 
		local grav = calc.gPull(self, child)
		local dist = calc.distance(self.x, self.y, child.x, child.y)

		-- Reworked planetary gravity, now works with multiple layers of parent-children. Also more realistc?? 
		local angle = math.atan((child.y-self.y)/(child.x-self.x))
		if self.x < child.x then 
			angle = angle - 3.14159
		end
		child.orbitalX = self.xSpeed + self.orbitalX
		child.orbitalY = self.ySpeed + self.orbitalY
		child.xSpeed = child.xSpeed + grav/child.m*math.cos(angle)*1e9
		child.ySpeed = child.ySpeed + grav/child.m*math.sin(angle)*1e9
	end 

	--Attracting the player


	-- IF IN SPHERE OF INFLUENCE
	local grav = calc.gPull(self, player)
	local dist = calc.distance(self.x, self.y, player.x, player.y)
	local pull = 20/dist * grav 

	player.xSpeed = player.xSpeed - (player.x - self.x)*pull
	player.ySpeed = player.ySpeed - (player.y - self.y)*pull
end


-- MAIN

function Planet:update(dt)
	self:attract(dt)
	self:updatePosition()
	for i, child in ipairs(self.children) do 
		child:update(dt)
	end
end


function Planet:draw()
	local col = self.colour
	love.graphics.setColor(calc.c(col[1]), calc.c(col[2]), calc.c(col[3]))
	love.graphics.circle("fill", self.x, self.y, self.r)
	love.graphics.setColor(0.1,0.1,0.1,0.2)
	love.graphics.circle("fill", self.x, self.y, self.r*2)
end