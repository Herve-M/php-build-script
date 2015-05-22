displayMessage "[PHP-5.6.X]"

if [ "$ARG_NEW_INSTALL" = true ]; then
  cp FILE/php/init.d/php-5.6-fpm /etc/init.d/
  cp FILE/php/PHP/5.6/php-fpm.conf /etc/PHP/5.6/
  cp FILE/php/PHP/5.6/php.ini /etc/PHP/5.6/
fi

if [ "$ARG_REFRESH_EXT" != true ]; then
  #Download
  _PHP_ARCHIVE=$(echo $MIRROR | sed -e "s/FILE/${PHP_56_FILE}/g")
  _PHP_ARCHIVE_SIG=$(echo $MIRROR | sed -e "s/FILE/${PHP_56_FILE}${SIG_FILE_EXT}/g")

  displayAndExec "\\ Download PHP archive      " "wget -N --content-disposition ${_PHP_ARCHIVE} -P SRC/PHP/"
  displayAndExec "\\ Download PHP archive sig  " "wget -N --content-disposition ${_PHP_ARCHIVE_SIG} -P SRC/PHP/"

  if [ ! -f SRC/PHP/$PHP_56_FILE ]
  then
      displayErrorAndExit 1 "Error : $SRC/$PHP_56_FILE not exist."
  fi

  if [ ! -f SRC/PHP/$PHP_56_FILE$SIG_FILE_EXT ]
  then
      displayErrorAndExit 1 "Error : $SRC/$PHP_56_FILE$SIG_FILE_EXT not exist."
  fi

  #Verify
  displayAndExec "\\ Add GPG Key      " "gpg --keyserver keyserver.ubuntu.com --recv-keys $PHP_56_GPG_KEY"

  _KEY_FGP=$(gpg --with-colons --fingerprint $PHP_56_GPG_KEY | awk -F: '$1 == "fpr" {print $10;}')

  if [ "$_KEY_FGP" != "$PHP_56_GPG_FGP" ]
  then
    displayErrorAndExit 1 "Error : key fingerprint ins't valide"
  fi

  displayAndExec "\\ Verify PHP archive      " "gpg --verify SRC/PHP/$PHP_56_FILE$SIG_FILE_EXT SRC/PHP/$PHP_56_FILE"
  displayAndExec "\\ Extract PHP archive     " "tar Jxf SRC/PHP/$PHP_56_FILE --directory SRC/PHP/"

  #Build step
  folder=${PHP_56_FILE%.tar.xz}
  cd SRC/PHP/$folder
  displayAndExec "\\ Configure PHP           " "$PHP_56_BCONF"
  displayAndExec "\\ Bulding PHP             " "make -j $NB_CORE"
  #Install step
  displayAndExec "\\ Shutting down PHP       " "sudo service php-5.6-fpm stop"
  displayAndExec "\\ Installing PHP          " "sudo make install"

  cd ../../..
fi

[ ! -x $PHP_INSTALL_FOLDER$PHP_56_FOLDER/bin/phpize ] && displayErrorAndExit 1 "Error : phpize for PHP 5.6 don't exist"

cd SRC/EXT/

#Ext step
for D in `find . -mindepth 1 -maxdepth 1 -type d`
do
  cd $D
  if [[ $D == *"cphalcon"* ]]; then
    cd build/64bits
    #export CFLAGS="-O2 --fvisibility=hidden"
    $PHP_INSTALL_FOLDER$PHP_56_FOLDER/bin/phpize 1>/dev/null
    displayAndExec "\\ Configuring $D      " "./configure --enable-phalcon --with-php-config=$PHP_INSTALL_FOLDER$PHP_56_FOLDER/bin/php-config"
    displayAndExec "\\ Bulding EXT         " "make -j $NB_CORE"
    displayAndExec "\\ Installing EXT      " "sudo make install"
    displayAndExec "\\ Cleaning EXT        " "make clean && $PHP_INSTALL_FOLDER$PHP_56_FOLDER/bin/phpize --clean"
    #unset CFLAGS
    cd ../..
  elif [[ $D != *"ZendOptimizer"* ]]; then
    $PHP_INSTALL_FOLDER$PHP_56_FOLDER/bin/phpize 1>/dev/null
    displayAndExec "\\ Configuring $D      " "./configure --with-php-config=$PHP_INSTALL_FOLDER$PHP_56_FOLDER/bin/php-config"
    displayAndExec "\\ Bulding EXT         " "make -j $NB_CORE"
    displayAndExec "\\ Installing EXT      " "sudo make install"
    displayAndExec "\\ Cleaning EXT        " "make clean && $PHP_INSTALL_FOLDER$PHP_56_FOLDER/bin/phpize --clean"
  fi
  cd ..
done

cd ../..
