#!/bin/bash
echo -e "\e[1;33m Building .exe! \e[0m"
doZip=true
path="./.build"

# Windows Folder
winPATH=$path"/builds/$1-win"
mkdir "$winPATH"

# Creating .exe
cat $path"/love/love.exe" $path"/builds/$1.love" > "$1.exe"
mv "$1.exe" "$winPATH"

# Moving dll's
cp $path"/win/"* "$winPATH"

# Zip it if $doZip == "true"
if [[ $doZip == "true" ]]; then
	name=$1"-win.zip"
	zip "$path/builds/$name" -r "$winPATH" 
	rm -rf "$winPATH"
fi