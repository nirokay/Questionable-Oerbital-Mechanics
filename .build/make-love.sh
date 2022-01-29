#!/bin/bash
zip -9 -r $1.love . -x ./.build/**\* ./.git/**\*
mv $1.love ./.build/builds
