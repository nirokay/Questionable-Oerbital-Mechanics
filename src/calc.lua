calc = {}


-- G-Constant
calc.G = 6.67e-11 -- TWEAKABLE FOR LATER DEPENDING ON SCALE!!!!!!!!!!!
calc.pi = 3.14

-- Development debugging/logging thing
function calc.debug(text)
	if calc.isDebug then
		local cDev = clr.fg.RED
		local cText = clr.fg.YELLOW
		local cReset = clr.reset
		print(cDev.."DEV: "..cText..text..cReset)
	end
end

-- Turn 0-1 colour to 0-range (default: 255):
function calc.setColour(r, g, b, a)
	-- Supported Inputs:
	-- 	 RGB:        (r, g, b, a)
	--   Greyscale:  (luminance, a)
	local range = 255

	-- Set g and b value to r if in greyscale and :
	if b == nil and a == nil then
		a = g
		g, b = r, r
	end
	-- Colour Conversion (0-1 -> 0-range)
	r, g, b = r/range, g/range, b/range

	-- If alpha not provided, set to 1 by default:
	if a == nil then a = 1 end

	-- Change Draw Colour:
	love.graphics.setColor(r, g, b, a)
end

-- Distance Formula:
function calc.distance(x1, y1, x2, y2)
	return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

-- Calculates the gravitational pull between two objects:
function calc.gPull(obj1, obj2)
	local dist = calc.distance(obj1.x, obj1.y, obj2.x, obj2.y)
	local grav = calc.G * (obj1.m * obj2.m) / dist^2
	return grav
end

-- Calculate closest space object to target:
function calc.closestObj(target)
	local minDist = calc.distance(planet[1].x, planet[1].y, target.x, target.y)-planet[1].r
	local minPlanet = planet[1]
	for i, pla in ipairs(planet) do 
		if calc.distance(pla.x, pla.y, target.x, target.y)-pla.r < minDist then 
			minDist = calc.distance(pla.x, pla.y, target.x, target.y)-pla.r
			minPlanet = pla
		end 
	end

	return minPlanet 
end

-- Loops through a table and concatenate all stings (for textboxes)
function calc.getText(stringTable)
	local string = ""
	for i, s in ipairs(stringTable) do
		string = string .. s
	end
	return string
end

return calc