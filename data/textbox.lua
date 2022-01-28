-- Storage for longer text strings and dialogue (?) in future for primarily textboxes

text = {
	tutorial = {
		"Throttle:\n",
		"  " .. controls.flight.throttle.up .. ", " .. controls.flight.throttle.down .. "  -  Changes your throttle (gui box left bottom)\n",
		"  " .. controls.flight.throttle.full .. ", " .. controls.flight.throttle.none .. "  -  Quick toggle full or no thrust\n\n",

		"Engines:\n",
		"  " .. controls.flight.thrust.engine .. "  -  Hold to activate your main engine",
		"  " .. controls.flight.thrust.up .. ", "..controls.flight.thrust.left .. ", " .. controls.flight.thrust.down .. ", " .. controls.flight.thrust.right .. "  -  Small thrust in the four directions\n\n",

        "Steering:\n",
		"  " .. controls.flight.thrust.rotleft .. ", " .. controls.flight.thrust.rotright .. "  -  Rotate spacecraft left and right\n\n",

		"Time Warp:\n",
		"  " .. controls.flight.warp.up .. ", " .. controls.flight.warp.down .. " (period and comma)  -  Speed time warp up/down \n",
		"  " .. controls.flight.warp.reset .. " (minus)  -  Reset time warp to default (1)\n\n",

		"Camera:\n",
		"  " .. "Scroll mouse wheel" .. "  -  Zoom in and out\n",
		"  " .. "Mouse Button "..controls.camera.zoom.reset .. "  -  Reset zoom to default\n\n\n",

		"Key bindings can be changed in game files [data/controls.lua]!"
	}
}

return text