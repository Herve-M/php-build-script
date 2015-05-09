#!/bin/bash

#Init
MY_DIR=$(dirname $(readlink -f $0))

##INCLUDE
#Options
source "${MY_DIR}/inc.option.sh"
#Alias
source "${MY_DIR}/inc.alias.sh"
#Functions
source "${MY_DIR}/inc.func.sh"
#Versions
source "${MY_DIR}/inc.version.sh"

displayTitle "Server PHP Build Script"


#
for f in `ls $MY_DIR/build.d/_* | sort -g`; do
	source "$f"
done
