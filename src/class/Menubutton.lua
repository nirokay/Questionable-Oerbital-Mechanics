Menubutton = Class {}

function Menubutton:init(tempX, tempY, tempW, tempH, tempState, tempFormat, tempText, tempTC, tempBC)
    -- Position and Dimensions:
	self.x = tempX
    self.y = tempY
    self.w = tempW
    self.h = tempH

    -- State to jump to:
    self.toState = tempState

    -- Formatting:
    self.format = tempFormat
    if self.format == "center" or self.format == "centre" then
        self.x = self.x - self.w
        self.y = self.y - self.h
    end

    -- Text and Colours:
    self.text = tempText
    self.colour = {
        text = tempTC,
        background = tempBC
    }
end



-- FUNCTIONS

function Menubutton:hover()
    local hover = false
    local x,y = love.mouse.getPosition()
    if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
        hover = true
    end
    return hover
end

function Menubutton:click()
    local click = false
    if self:hover() and love.mouse.isDown(1) then
        click = true
    end
    return click
end



-- MAIN

function Menubutton:update(dt)
    if self:click() then
        -- Here is room for calling effects or something... looking at you madi qwq xD
        GAMESTATE = self.toState
    end
end

function Menubutton:draw()
    local x, y, w, h = self.x, self.y, self.w, self.h
    local bg, tx = self.colour.background, self.colour.text

    -- Hover Effects:
    if self:hover() then
        -- Slight pop up effect (purly visual):
        local pop = 3
        x, y, w, h = x-pop, y-pop, w+pop*2, h+pop*2
    end

    -- Draw Background
    calc.setColour(bg[1], bg[2], bg[3], bg[4])
    love.graphics.rectangle("fill", x, y, w, h)

    -- Draw Text
    love.graphics.setFont(font.default)
    calc.setColour(tx[1], tx[2], tx[3], tx[4])
    love.graphics.printf(self.text, x, y, w, "center")
end