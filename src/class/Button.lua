Button = Class {}

function Button:init(tempX, tempY, tempW, tempH, tempText, tempTC, tempBC, tempActive)
    -- Position and Dimensions:
	self.x = tempX
    self.y = tempY
    self.w = tempW
    self.h = tempH

    -- Status:
    self.isActive = tempActive

    -- Text and Colours:
    self.text = tempText
    self.colour = {
        text = calc.colour(tempTC[1], tempTC[2], tempTC[3]),
        background = calc.colour(tempBC[1], tempBC[2], tempBC[3])
    }

    -- Click Cooldown:
    self.cooldownLimit = 30
    self.cooldown = 0
end


-- FUNCTIONS 

function Button:hover()
    local hover = false
    local x,y = love.mouse.getPosition()
    if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
        hover = true
    end
    return hover
end

function Button:click()
    local click = false
    if self:hover() and love.mouse.isDown(1) then
        click = true
    end
    return click
end


-- MAIN

function Button:update(dt)
    if self:click() and self.cooldown <= 0 then
        self.isActive = not self.isActive
        self.cooldown = self.cooldownLimit
    end
    self.cooldown = self.cooldown - 1
end

function Button:draw()
    local x, y, w, h = self.x, self.y, self.w, self.h
    local bg, tx = self.colour.background, self.colour.text

    -- Hover Effects
    if self:hover() and self.cooldown <= 0 then
        --[[ Slight Colour Lightup                         -- broken and idk why qwq
        for i = 1, #bg do
            bg[i] = bg[i]*1.1
        end]]

        -- Slight pop up effect (purly visual)
        local pop = 1
        x, y, w, h = x-pop, y-pop, w+pop*2, h+pop*2
    end

    -- Draw Background
    love.graphics.setColor(bg[1], bg[2], bg[3])
    love.graphics.rectangle("fill", x, y, w, h)

    -- Draw Text
    love.graphics.setFont(font.default)
    love.graphics.setColor(tx[1], tx[2], tx[3])
    love.graphics.printf(self.text, x, y, w, "center")
end