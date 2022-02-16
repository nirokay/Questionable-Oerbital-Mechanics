#!/bin/bash
echo -e "\e[1;33m Building .love \e[0m"
zip -9 -r $1.love . -x ./.build/**\* ./.git/**\*
mv $1.love ./.build/builds