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

ARG_NEW_INSTALL=false
ARG_REFRESH_EXT=false
ARG_START_PHP=false
ARG_BEXT_PHP54=false
ARG_BEXT_PHP55=false
ARG_BEXT_PHP56=false

function usage()
{
    echo "PHP Build Script"
    echo ""
    echo "./build.sh"
    echo "\t-h --help"
    echo "\t--install For creating base folder"
    echo "\t--only-ext For only update ext"
    echo ""
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --install)
					ARG_NEW_INSTALL=true
            ;;
        --only-ext)
					ARG_REFRESH_EXT=true
          ARG_BEXT_PHP54=true
          ARG_BEXT_PHP55=true
          ARG_BEXT_PHP56=true
            ;;
        --update-php54-ext)
					ARG_BEXT_PHP54=true
            ;;
        --update-php55-ext)
					ARG_BEXT_PHP55=true
            ;;
        --update-php56-ext)
					ARG_BEXT_PHP56=true
            ;;
        --start-php)
          ARG_START_PHP=true
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

#
for f in `ls $MY_DIR/build.d/_* | sort -g`; do
	source "$f"
done
