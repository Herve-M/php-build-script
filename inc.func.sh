# Functions
#-----------------------------------------------------------------------------

displayTitle() {
    displayMessage "------------------------------------------------------------------------------"
    displayMessage "$*"
    displayMessage "------------------------------------------------------------------------------"

}

displayMessage() {
    echo "$*"
}
displayError() {
    displayMessage "$*" >&2
}

# First parameter: ERROR CODE
# Second parameter: MESSAGE
displayErrorAndExit() {
    local exitcode=$1
    shift
    displayError "$*"
    exit $exitcode
}

# First parameter: MESSAGE
# Others parameters: COMMAND (! not |)
displayAndExec() {
	local message=$1
	echo -n "[En cours] $message"
	shift
	echo ">>> $*" >> $LOG_FILE 2>&1
	sh -c "$*" >> $LOG_FILE 2>&1
	local ret=$?
	if [ $ret -ne 0 ]; then
		echo -e "\r\e[0;31m [ERROR]\e[0m $message"
	else
		echo -e "\r\e[0;32m [OK]\e[0m $message"
	fi
	return $ret
}

compress2TarXZ() {
    XZ_OP=-3 tar -Jcvf $1.tar.xz $1
}

downloadFile() {
  _file=$1;
  displayAndExec "\\ Downloading file.      " "wget --content-disposition ${_file} -P SRC/"
}

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    displayErrorAndExit "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
 else
    if [ -f "$1" ] ; then
        NAME=${1%.*}
        #mkdir $NAME && cd $NAME
        case "$1" in
          *.tar.bz2)   tar xjf ./"$1"    ;;
          *.tar.gz)    tar xzf ./"$1"    ;;
          *.tar.xz)    tar xJf ./"$1"    ;;
          *.lzma)      unlzma ./"$1"      ;;
          *.bz2)       bunzip2 ./"$1"     ;;
          *.rar)       unrar x -ad ./"$1" ;;
          *.gz)        gunzip ./"$1"      ;;
          *.tar)       tar xf ./"$1"     ;;
          *.tbz2)      tar xjf ./"$1"    ;;
          *.tgz)       tar xzf ./"$1"    ;;
          *.zip)       unzip ./"$1"       ;;
          *.Z)         uncompress ./"$1"  ;;
          *.7z)        7z x ./"$1"        ;;
          *.xz)        unxz ./"$1"        ;;
          *.exe)       cabextract ./"$1"  ;;
          *)           displayError "extract: '$1' - unknown archive method" ;;
        esac
    else
      displayError "'$1' - file does not exist"
    fi
fi
}
