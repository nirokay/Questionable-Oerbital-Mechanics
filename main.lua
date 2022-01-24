function love.load()
	require "import"
	-- Debugging / Logging:
	debug = calc.debug
	calc.isDebug = true

	-- Declaration:
	love.window.setTitle(info.name.." - v"..info.version)
	width, height = love.graphics.getDimensions()

	-- Gamestate:
	gamestate = {
		quit = "stateQUIT",
		menu = "stateMENU",
		game = "stateGAME"
	}
	GAMESTATE = gamestate.menu

	-- Menubuttons:
	menubutton = {
		menu = {
			Menubutton(20, 100, 200, 50, gamestate.game, nil, "Start Game", {255, 255, 255}, {57, 45, 66}),
			Menubutton(30, 170, 180, 40, gamestate.quit, nil, "Quit Game", {255, 255, 255}, {57, 45, 66})
		},
		game = {
			-- Pause button or something here in future?
		}
	}


	-- Camera:
	cam = Camera()
	zoomlevel = settings.zoom.reset

	--Simulation:
	warpspeed = 1
	warpCoolDown = 0

	-- Loading:
	ships = {}				--Potentially add other starships in the future?

	planet = {}
	loadPlanets()

	local spawnPlanet = planet[1]
	player = Player(spawnPlanet.x, spawnPlanet.y-spawnPlanet.r-1, "orbiter")
	player.xSpeed, player.ySpeed = spawnPlanet.xSpeed, spawnPlanet.ySpeed
	gui = Gui(1)
	effects = {}
end


-- Planets:

function loadPlanets()
	debug("Planets in planet table: "..#planetdata)
	for i, p in ipairs(planetdata) do
		debug(p.name.." is loading")
		table.insert(planet, i, 
			Planet(
				-- Planet Data Assignment:
				p.x, p.y,
				p.r, p.m,
				p.xSpeed, p.ySpeed,
				p.name,
				p.colour,
				p.parent
			)
		)
		debug(p.name.." is loaded")
	end
	debug("Planets loaded: "..#planet)
end

function updatePlanets()
	planet[1]:update()
end

function drawPlanets()
	for i=1, #planet do
		planet[i]:draw()
		--debug("Drawing planet " .. i)
	end
end


-- Effects

function drawEffects()
	for i=1, #effects do 
		effects[i]:draw()
	end
	for i, effect in ipairs(effects) do    			--Separate functions because if I remove something while processing it it WILL lead to an error
		if effect.finished then 
			table.remove(effects, i)
		end
	end 
end


-- Camera

function cameraControls()
	local step = settings.zoom.step

	function love.wheelmoved(x, y)
		if y > 0 then
			-- Zoom in:
			zoomlevel = zoomlevel + step*(zoomlevel*10)
		elseif y < 0 then
			-- Zoom out:
			zoomlevel = zoomlevel - step*(zoomlevel*10)
		end
	end

	-- Reset Zoom:
	if love.mouse.isDown(controls.camera.zoom.reset) then
		zoomlevel = settings.zoom.reset
	end

	-- Zoom Limit:
	local max = settings.zoom.max
	local min = settings.zoom.min
	if zoomlevel < min then
		zoomlevel = min
	end
	if zoomlevel > max then
		zoomlevel = max
	end
	--debug(zoomlevel)
	cam:zoomTo(zoomlevel)
end


-- Time Warp

function timewarpControls()
	-- Time Warp Toggle Cooldowns:
	local maxCooldown = settings.warp.cooldown
	
	-- Time Warp Steps:
	local step = settings.warp.step
	-- Time Warp Limits:
	local min = settings.warp.min
	local max = settings.warp.max

	-- Decrease Warp
	if love.keyboard.isDown(controls.flight.warp.down) and warpCoolDown <= 0 then
		warpspeed = warpspeed - step
		warpCoolDown = maxCooldown
	end
	-- Increase Warp
	if love.keyboard.isDown(controls.flight.warp.up) and warpCoolDown <= 0 then
		warpspeed = warpspeed + step
		warpCoolDown = maxCooldown
	end
	-- Reset Warp
	if love.keyboard.isDown(controls.flight.warp.reset) then
		warpspeed = min
	end

	-- Value Correction
	if warpspeed < min then
		warpspeed = min
	elseif warpspeed > max then 
		warpspeed = max
	end

	warpCoolDown = warpCoolDown - 1
	return warpspeed
end


-- Menubuttons

function menubuttonUpdate()
	if GAMESTATE == gamestate.menu then
		for i, button in ipairs(menubutton.menu) do
			button:update()
		end

	elseif GAMESTATE == gamestate.game then
		for i, button in ipairs(menubutton.game) do
			button:update()
		end

	end
end

function menubuttonDraw()
	if GAMESTATE == gamestate.menu then
		for i, button in ipairs(menubutton.menu) do
			button:draw()
		end

	elseif GAMESTATE == gamestate.game then
		for i, button in ipairs(menubutton.game) do
			button:draw()
		end
	end
end


-- MAIN

function love.update(dt)
	if GAMESTATE == gamestate.quit then
		debug("Game has been quit, goodbye :)")
		love.event.quit(0)

	elseif GAMESTATE == gamestate.menu then

	elseif GAMESTATE == gamestate.game then
		-- Game Objects:
		for i=1, timewarpControls() do
			-- Physics go in here:
			updatePlanets()
			player:update(dt)
		end
		player:throttleControls()

		-- Gui:
		gui:update(dt)

		-- Camera:
		cam:lookAt(player.x, player.y)
		cameraControls()
		--debug(player.x .. " " .. player.y)

		
	end
	menubuttonUpdate()
end

function love.draw()
	if GAMESTATE == gamestate.menu then
		-- Game Title:
		love.graphics.setColor(1, 1, 0.6)
		love.graphics.setFont(font.gametitle)
		love.graphics.printf(info.title, 20, 20, width, "left")

	elseif GAMESTATE == gamestate.game then
		cam:attach()
			-- Game Objects:
			drawPlanets()
			drawEffects()
			player:draw()
		cam:detach()

		-- Gui:
		player:drawPositionIndicator()
		gui:draw()
	end
	menubuttonDraw()
end