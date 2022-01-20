require "import"
-- Debugging / Logging:
debug = calc.debug
calc.isDebug = true

function love.load()
	-- Declaration:
	love.window.setTitle(info.name.." - v"..info.version)
	width, height = love.graphics.getDimensions()
	cam = Camera()
	zoomlevel = 1

	-- Loading:
	planet = {}
	loadPlanets()

	local spawnPlanet = planet[1]
	player = Player(spawnPlanet.x, spawnPlanet.y-spawnPlanet.r-1)
	gui = Gui(1)
end


-- Planets:

function loadPlanets()
	debug("Planets in planet table: "..#planetdata)
	for i=1, #planetdata do
		local p = planetdata[i]
		debug(p.name.." is loading")
		table.insert(planet, i, 
			Planet(
				-- Planet Data Assignment:
				p.x, p.y,
				p.r, p.m,
				p.name,
				p.colour
			)
		)
		debug(p.name.." is loaded")
	end
	debug("Planets loaded: "..#planet)
end

function updatePlanets()
	for i=1, #planet do
		planet[i]:update()
	end
end

function drawPlanets()
	for i=1, #planet do
		planet[i]:draw()
	end
end




-- Camera



function cameraControls()
	local zooming = 0.01

	function love.wheelmoved(x, y)
		if y > 0 then
			-- Zoom in:
			zoomlevel = zoomlevel + zooming
		elseif y < 0 then
			-- Zoom out:
			zoomlevel = zoomlevel - zooming
		end
	end

	-- Reset Zoom:
	if love.mouse.isDown(3) then
		zoomlevel = 1
	end

	-- Zoom Limit:
	local max = 4
	local min = 0.001
	if zoomlevel < min then
		zoomlevel = min
	end
	if zoomlevel > max then
		zoomlevel = max
	end
	--debug(zoomlevel)
	cam:zoomTo(zoomlevel)
end



-- MAIN

function love.update(dt)
	-- Game Objects:
	updatePlanets()
	player:update(dt)

	-- Gui:
	gui:update(dt)

	-- Camera:
	cam:lookAt(player.x, player.y)
	cameraControls()
end

function love.draw()
	cam:attach()
		-- Game Objects:
		drawPlanets()
		player:draw()

		-- Camera Zoom Player Location Indicator:                              OVERWORK SOON PLS KAY; IT UGLY
		if zoomlevel < 0.3 then
			love.graphics.setColor(1, 1, 1, 0.2)
			love.graphics.circle("fill", player.x, player.y, (1/zoomlevel)*10)
		end
	cam:detach()

	-- Gui:
	gui:draw()
end