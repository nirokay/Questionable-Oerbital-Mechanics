#!/bin/bash
project=$1

# Check if main.lua exists:
if [[ ! -f "main.lua" ]]; then
	echo -e "\e[31m !! Could not find main.lua file, terminating build process !! \e[0m"
	exit 1
fi

# Give Permissions and check for build directory:
chmod +x -R ./.build
if [[ ! -d ./.build/builds ]]; then
	mkdir ./.build/builds
fi

# Build .love
./.build/make-love.sh $project

# Build .exe
./.build/make-exe.sh $project

# End
echo -e "\e[1;33m Finished Building Project! \e[0m"
exit 0