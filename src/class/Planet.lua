Planet = Class {}

function Planet:init(tempX, tempY, tempR, tempM, tempXSpeed, tempYSpeed, tempName, tempC, tempP)
	-- Planet Position:
	self.x = tempX
	self.y = tempY

	-- Speed:
	self.xSpeed = 0
	self.ySpeed = 0

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

function Planet:updatePosition()
	self.x = self.x + self.xSpeed
	self.y = self.y + self.ySpeed
	debug("Updating position of planet " .. self.name .. ": " .. self.x .. " " .. self.y)
end

function Planet:attract(dt)		--Planet doing the attracting, divided in two parts:	
	--Attracting children
	for i, child in ipairs(self.children) do 
		local grav = calc.gPull(self, child)
		local dist = calc.distance(self.x, self.y, child.x, child.y)
		local pull = 20/dist * grav
	
		child.xSpeed = child.xSpeed - (child.x - self.x)*pull
		child.ySpeed = child.ySpeed - (child.y - self.y)*pull
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
	
end