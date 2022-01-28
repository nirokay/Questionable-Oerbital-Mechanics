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

-- 0-255 colour to 0-1 colour (returns a table)
function calc.colour(r, g, b)
	return { r/255, g/255, b/255 }
end

-- 0-255 colour value to 0-1 colour value
function calc.c(value)
	return value/255
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