controls = {
	-- Player Flight Controls:
	flight = {
		-- Respawn on Starting Location:
		reset = "r",

		-- Change Throttle:
		throttle = {
			up =     "lshift",
			down =   "lctrl",

			full =   "y",
			none =   "x"
		},

		-- Directional Thrust:
		thrust = {
			up =     "w",
			down =   "s",
			left =   "a",
			right =  "d",
			engine = "space",
			rotleft = "q",
			rotright = "e"
		},

		-- Time Warp Controls:
		warp = {
			reset =  "-",
			down =   ",",
			up =     "."
		},

		-- Special
		special = "f"
	},
	
	-- Player Camera Controls:
	camera = {
		zoom = {
			reset =  3 -- (Middle Mouse Button)
		}
	}
}

return controls