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
        text = tempTC,
        background = tempBC
    }
end


-- FUNCTIONS

function Textbox:drawBox()
    local col = self.colour.background
    calc.setColour(col[1], col[2], col[3], 0.7)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Textbox:drawText()
    local border = 3
    local col = self.colour.text
    love.graphics.setFont(font.default)
    calc.setColour(col[1], col[2], col[3])
    love.graphics.printf(self.text, self.x + border, self.y + border, self.w + border*2, self.align)
end



-- MAIN

function Textbox:draw()
    self:drawBox()
    self:drawText()
end