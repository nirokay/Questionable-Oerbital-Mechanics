# Questionable Örbital Mechanics

## What is this?
Questionable Örbital Mechanics - or as we like to call it: *QÖM* - is an open-source Space Simulation "Game" written in Lua using the Löve game engine.

For now it is very basic, as it is still heavily in development.


## How do i play this game?
In order to play this game you need to ...
1) ...have the Lua (5.4.3) programming language installed (optional, as Löve comes with Lua)
1) ...have the Löve (11.3) game engine installed

For now this is the only way to play this game. In future there will be binary versions availabe.


### Installing Lua (optional)
Arch Linux:
`sudo pacman -S lua`

Windows:
https://www.lua.org/download.html

### Installing Love 
Arch Linux: 
`sudo pacman -S love`

Debian/Ubuntu Linux:
`sudo snap install love`

Windows:
https://love2d.org


## Building from source code
The script `build.sh` takes an argument (the project output name).

Simply execute `./build.sh [insert project name]` in your terminal. The builder compiles to a windows executable (.exe) and an executable love (.love) file.

Builds can be found in `./.build/builds/`!


## What's new?
*here will come changelogs in future*
