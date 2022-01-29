#!/bin/bash
project=$1

# Give Permissions
chmod +x -R ./.build

# Build .love
./.build/make-love.sh $project

# Build .exe
./.build/make-exe.sh $project
