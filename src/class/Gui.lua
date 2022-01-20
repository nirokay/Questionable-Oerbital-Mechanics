Gui = Class {}

function Gui:init(tempScale)
	self.scale = tempScale
end


-- FUNCTIONS

function Gui:drawSpeed()
	local speed = player:getSpeed()

	-- Drawing
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf(speed, 5, 45, width, "left")
end

function Gui:drawWarp()
	local warp = player.warpspeed
	love.graphics.setColor(1, 1, 1)
	love.graphics.printf("Warp Speed: x"..warp, 5, 5, width, "left")
end

function Gui:drawThrottle()
	local offset = 15
	local border = 10
	local w,h = 60, 140
	local x, y = 0, height-h

	x, y = x+offset, y-offset

	-- Draw Border:
	local BDcol = 0.1
	love.graphics.setColor(BDcol, BDcol, BDcol)
	love.graphics.rectangle("fill", x, y, w, h)

	x, y = x+border, y+border
	w, h = w-border*2, h-border*2

	-- Draw Background:
	local BGcol = 0.4
	love.graphics.setColor(BGcol, BGcol, BGcol)
	love.graphics.rectangle("fill", x, y, w, h)

	-- Draw Throttle:
	love.graphics.setColor(1, 1, 1)
	local change = h*player.throttle
	love.graphics.rectangle("fill", x, (y+h)-change, w, change)
end



-- MAIN

function Gui:update(dt)
end

function Gui:draw()
	self:drawThrottle()
	self:drawWarp()
	self:drawSpeed()
end