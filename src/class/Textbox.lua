Textbox = Class {}

function Textbox:init(tempX, tempY, tempW, tempH, tempText, tempAlign, tempTC, tempBC)
    -- Dimensions:
    self.x = tempX
    self.y = tempY
    self.w = tempW
    self.h = tempH

    -- Text:
    self.text = tempText
    self.align = tempAlign

    -- Colours:
    self.colour = {
        text = calc.colour(tempTC[1], tempTC[2], tempTC[3]),
        background = calc.colour(tempBC[1], tempBC[2], tempBC[3])
    }
end


-- FUNCTIONS

function Textbox:drawBox()
    local c = self.colour.background
    love.graphics.setColor(c[1], c[2], c[3], 0.7)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Textbox:drawText()
    local border = 3
    local c = self.colour.text
    love.graphics.setFont(font.default)
    love.graphics.setColor(c[1], c[2], c[3])
    love.graphics.printf(self.text, self.x + border, self.y + border, self.w + border*2, self.align)
end



-- MAIN

function Textbox:draw()
    self:drawBox()
    self:drawText()
end