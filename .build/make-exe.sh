#!/bin/bash
path="./.build"

# Windows Folder
winPATH=$path"/builds/"$1"-win"
mkdir $winPATH

# Creating .exe
cat $path"/love/love.exe" $path"/builds/"$1.love > $1.exe
mv $1.exe $winPATH

# Moving dll's
cp $path"/win/"* $winPATH
