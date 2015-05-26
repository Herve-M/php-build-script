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

if [ "$ARG_NEW_INSTALL" = true ]; then
  mkdir -p /var/log/PHP/{5,6,5.5,5.4,5.3}
  mkdir -p /var/run/PHP/{5,6,5.5,5.4,5.3}
  mkdir -p /etc/PHP/{5,6,5.5,5.4,5.3}
  cat FILE/fstab >> /etc/fstab
fi

#
for f in `ls $MY_DIR/build.d/_* | sort -g`; do
	source "$f"
done

if [ "$ARG_NEW_INSTALL" = true ]; then
  mount -a
fi
