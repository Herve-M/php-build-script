displayMessage "[PHP-5.4.X]"

#Download
_PHP_ARCHIVE=$(echo $MIRROR | sed -e "s/FILE/${PHP_54_FILE}/g")
_PHP_ARCHIVE_SIG=$(echo $MIRROR | sed -e "s/FILE/${PHP_54_FILE}${SIG_FILE_EXT}/g")

displayAndExec "\\ Download PHP archive      " "wget -N --content-disposition ${_PHP_ARCHIVE} -P SRC/PHP/"
displayAndExec "\\ Download PHP archive sig  " "wget -N --content-disposition ${_PHP_ARCHIVE_SIG} -P SRC/PHP/"

if [ ! -f SRC/PHP/$PHP_54_FILE ]
then
    displayErrorAndExit 1 "Error : $SRC/$PHP_54_FILE not exist."
fi

if [ ! -f SRC/PHP/$PHP_54_FILE$SIG_FILE_EXT ]
then
    displayErrorAndExit 1 "Error : $SRC/$PHP_54_FILE$SIG_FILE_EXT not exist."
fi

#Verify
displayAndExec "\\ Add GPG Key      " "gpg --keyserver keyserver.ubuntu.com --recv-keys $PHP_54_GPG_KEY"

_KEY_FGP=$(gpg --with-colons --fingerprint $PHP_54_GPG_KEY | awk -F: '$1 == "fpr" {print $10;}')

if [ "$_KEY_FGP" != "$PHP_54_GPG_FGP" ]
then
  displayErrorAndExit 1 "Error : key fingerprint ins't valide"
fi

displayAndExec "\\ Verify PHP archive      " "gpg --verify SRC/PHP/$PHP_54_FILE$SIG_FILE_EXT SRC/PHP/$PHP_54_FILE"
#displayAndExec "\\ Extract PHP archive     " "tar jxf SRC/PHP/$PHP_54_FILE --directory SRC/PHP/"

#Build step
folder=${PHP_54_FILE%.tar.bz2}
cd SRC/PHP/$folder
displayAndExec "\\ Configure PHP           " "$PHP_54_BCONF"
displayAndExec "\\ Bulding PHP             " "make -j 4"
#Install step
displayAndExec "\\ Shutting down PHP       " "service php-5.4-fpm stop"
displayAndExec "\\ Installing PHP          " "make install"

cd ../../..
cd SRC/EXT/

#Ext step
for D in `find . -mindepth 1 -maxdepth 1 -type d`
do
  /opt/PHP/5.4/bin/phpize
  displayAndExec "\\ Configuring $D      " "./configure --with-php-config=/opt/PHP/5.4/bin/php-config"
  displayAndExec "\\ Bulding EXT         " "make -j 4"
  displayAndExec "\\ Installing EXT      " "make install"
  displayAndExec "\\ Cleaning EXT        " "make clean && phpize --clean"
done

cd ../../..
