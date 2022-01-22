-- Effect object
FX = Class {}

function FX:init(type, x, y, target)
    self.type = type
    self.id = #effects
    self.frame = 0
    self.x = x 
    self.y = y 
    self.finished = false               -- So that main can kill it later. For some reason it does not want to kill itself.
    self.target = target
end


function FX:flash()
    love.graphics.setColor(1,1,1,1-self.frame/1000)
    love.graphics.circle("fill", self.x, self.y, self.frame)
    self.frame = self.frame  + 100/love.timer.getFPS()
    --debug("Frame is " .. self.frame)
    if self.frame > 500 then 
        self.target.exploding = false 
        self.target:reset()
    end
    if self.frame > 1000 then 
        self.finished = true 
    end
end



function FX:draw()
    --debug("drawing flash")
    if self.type == "flash" then 
        self:flash()
    end
end