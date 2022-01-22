-- List of all dependancies to import to main file

-- Libraries:
require "libraries"

-- General Data:
info = require "data/info"
texture = require "textures/textures"
controls = require "data/controls"
settings = require "data/settings"
<<<<<<< Updated upstream
texture = require "textures/textures"
<<<<<<< Updated upstream
starshipTypes = require "data/starshipTypes"
=======
=======
starshipTypes = require "data/starshipTypes"
>>>>>>> Stashed changes
>>>>>>> Stashed changes

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
