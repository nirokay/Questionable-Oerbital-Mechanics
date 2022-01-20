Planet = Class {}

function Planet:init(tempX, tempY, tempR, tempM, tempName, tempC)
	-- Planet Position
	self.x = tempX
	self.y = tempY

	-- Planet Radius and Mass
	self.r = tempR
	self.m = tempM

	-- Planet Data:
	self.name = tempName
	self.colour = tempC
end



-- FUNCTIONS




-- MAIN

function Planet:update(dt)
end

function Planet:draw()
	local col = self.colour
	love.graphics.setColor(calc.c(col[1]), calc.c(col[2]), calc.c(col[3]))
	love.graphics.circle("fill", self.x, self.y, self.r)
end