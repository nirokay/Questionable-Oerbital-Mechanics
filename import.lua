-- List of all dependancies to import to main file

-- Libraries:
require "libraries"

-- General Data:
info = require "data/info"
texture = require "textures/textures"
controls = require "data/controls"
settings = require "data/settings"
starshipTypes = require "data/starshipTypes"

-- Game Source:
calc = require "src/calc"
font = require "src/font"



-- Game Classes:
require "src/class/Player"
require "src/class/Gui"
require "src/class/Planet"
require "src/class/FX"

-- Game Data:
planetdata = require "data/planetdata"
