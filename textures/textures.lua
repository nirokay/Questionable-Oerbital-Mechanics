texture = {
    -- (G)UI Textures:
    ui = {
        arrow = {
            grey = love.graphics.newImage("textures/ui/arrow_grey.png"),
            red = love.graphics.newImage("textures/ui/arrow_red.png")
        }
    },

    -- Player/Spacecraft Textures:
    player = {
        -- Orbiter Spacecraft:
        orbiter = {
            ship = love.graphics.newImage("textures/player/orbiter/orbiter.png"),
            lowThrust = love.graphics.newImage("textures/player/orbiter/lowThrust.png"),
            fullThrust = love.graphics.newImage("textures/player/orbiter/fullThrust.png")
        }
    },

    -- Planet Textures:
    planet = {}
}

return texture