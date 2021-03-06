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
ARG_START_PHP=false
ARG_BUILD_PHP=true
ARG_BPHP_PHP55=false
ARG_BPHP_PHP56=false
ARG_BPHP_PHP70=false
ARG_BUILD_EXT=true
ARG_BEXT_PHP55=false
ARG_BEXT_PHP56=false
ARG_BEXT_PHP70=false

function usage()
{
    echo ""
    echo "./build.sh"
    echo "-h --help"
    echo "--install           | Full install, create folder, syslink and build all PHP versions + Ext"
    echo "--without-ext       | Update all verions of PHP"
    echo "--without-php       | Update all extensions of all PHP versions"
    echo "--update-php55      | Update PHP 5.5"
    echo "--update-php56      | Update PHP 5.6"
    echo "--update-php70      | Update PHP 7.0"
    echo "--update-php55-ext  | Update PHP 5.5 extensions"
    echo "--update-php56-ext  | Update PHP 5.6 extensions"
    echo "--update-php70-ext  | Update PHP 7.0 extensions"
    echo "--start-php         | Start PHP after install"
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
        --without-ext)
					ARG_BUILD_EXT=false
            ;;
        --without-php)
					ARG_BUILD_PHP=false
            ;;
        --update-php55)
          ARG_BUILD_EXT=false
          ARG_BUILD_PHP=false
					ARG_BPHP_PHP55=true
            ;;
        --update-php56)
          ARG_BUILD_EXT=false
          ARG_BUILD_PHP=false
					ARG_BPHP_PHP56=true
            ;;
        --update-php70)
          ARG_BUILD_EXT=false
          ARG_BUILD_PHP=false
          ARG_BPHP_PHP70=true
            ;;
        --update-php55-ext)
          ARG_BUILD_EXT=false
          ARG_BUILD_PHP=false
					ARG_BEXT_PHP55=true
            ;;
        --update-php56-ext)
          ARG_BUILD_EXT=false
          ARG_BUILD_PHP=false
					ARG_BEXT_PHP56=true
            ;;
        --update-php70-ext)
          ARG_BUILD_EXT=false
          ARG_BUILD_PHP=false
					ARG_BEXT_PHP70=true
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
