#!/bin/bash
echo -e "\e[1;33m Building .exe! \e[0m"
doZip=true
path="./.build"

# Windows Folder
winDir=$1-win
winPATH=$path"/builds/$winDir"
mkdir "$winPATH"

# Creating .exe
cat $path"/love/love.exe" $path"/builds/$1.love" > "$1.exe"
mv "$1.exe" "$winPATH"

# Moving dll's
cp $path"/love/"*".dll" "$winPATH"

# Zip it if $doZip == "true"
if [[ $doZip == "true" ]]; then
	currentPath=$( pwd )
	cd "$path/builds"
	name=$1"-win.zip"
	zip "$name" -r "$winDir"
	
	cd "$currentPath"
	rm -rf "$winPATH"
fi
