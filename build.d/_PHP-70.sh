displayMessage "[PHP-7.0.X]"

if [ "$ARG_BPHP_PHP70" = true ]||[ "$ARG_BUILD_PHP" = true ]; then

  if [ "$ARG_NEW_INSTALL" = true ]; then
    sudo mkdir -p /opt/PHP/7.0/{etc,var/log}
    sudo mkdir -p /etc/PHP/7.0/
    sudo cp FILE/php/init.d/php-7.0-fpm /etc/init.d/
    sudo cp FILE/php/PHP/7.0/php-fpm.conf /etc/PHP/7.0/
    sudo cp FILE/php/PHP/7.0/php.ini /etc/PHP/7.0/
    cat <<EOI | sudo tee -a /etc/fstab > /dev/null
  #PHP 7.0
  /etc/PHP/7.0 /opt/PHP/7.0/etc none bind 0 0
  /var/log/PHP/7.0 /opt/PHP/7.0/var/log none bind 0 0
EOI
    sudo mount -a
  fi

  #Download
  _PHP_ARCHIVE=$(echo $MIRROR | sed -e "s/FILE/${PHP_70_FILE}/g")
  _PHP_ARCHIVE_SIG=$(echo $MIRROR | sed -e "s/FILE/${PHP_70_FILE}${SIG_FILE_EXT}/g")

  displayAndExec "\\ Download PHP archive      " "wget -N --content-disposition ${_PHP_ARCHIVE} -P SRC/PHP/"
  displayAndExec "\\ Download PHP archive sig  " "wget -N --content-disposition ${_PHP_ARCHIVE_SIG} -P SRC/PHP/"

  if [ ! -f SRC/PHP/$PHP_70_FILE ]
  then
      displayErrorAndExit 1 "Error : $SRC/$PHP_70_FILE not exist."
  fi

  if [ ! -f SRC/PHP/$PHP_70_FILE$SIG_FILE_EXT ]
  then
      displayErrorAndExit 1 "Error : $SRC/$PHP_70_FILE$SIG_FILE_EXT not exist."
  fi

  #Verify
  displayAndExec "\\ Add GPG Key      " "gpg --keyserver keyserver.ubuntu.com --recv-keys $PHP_70_GPG_KEY"

  _KEY_FGP=$(gpg --with-colons --fingerprint $PHP_70_GPG_KEY | awk -F: '$1 == "fpr" {print $10;}')

  if [ "$_KEY_FGP" != "$PHP_70_GPG_FGP" ]
  then
    displayErrorAndExit 1 "Error : key fingerprint ins't valide"
  fi

  displayAndExec "\\ Verify PHP archive      " "gpg --verify SRC/PHP/$PHP_70_FILE$SIG_FILE_EXT SRC/PHP/$PHP_70_FILE"
  displayAndExec "\\ Extract PHP archive     " "tar Jxf SRC/PHP/$PHP_70_FILE --directory SRC/PHP/"

  #Build step
  folder=${PHP_70_FILE%.tar.xz}
  cd SRC/PHP/$folder
  displayAndExec "\\ Configure PHP           " "$PHP_70_BCONF"
  displayAndExec "\\ Bulding PHP             " "make -j $NB_CORE"
  #Install step
  displayAndExec "\\ Shutting down PHP       " "sudo service php-7.0-fpm stop"
  displayAndExec "\\ Installing PHP          " "sudo make install"
  displayAndExec "\\ Cleaning PHP            " "make clean"

  cd ../../..
fi

if [ "$ARG_BEXT_PHP70" = true ]||[ "$ARG_BUILD_EXT" = true ]; then
  [ ! -x $PHP_INSTALL_FOLDER$PHP_70_FOLDER/bin/phpize ] && displayErrorAndExit 1 "Error : phpize for PHP 7.0 don't exist"

  cd SRC/EXT/

  #Ext step
  for D in `find . -mindepth 1 -maxdepth 1 -type d`
  do
    cd $D
    if [[ $D == *"cphalcon"* ]]; then
      cd build/64bits
      #export CFLAGS="-O2 --fvisibility=hidden"
      $PHP_INSTALL_FOLDER$PHP_70_FOLDER/bin/phpize 1>/dev/null
      displayAndExec "\\ Configuring $D      " "./configure --enable-phalcon --with-php-config=$PHP_INSTALL_FOLDER$PHP_70_FOLDER/bin/php-config"
      displayAndExec "\\ Bulding EXT         " "make -j $NB_CORE"
      displayAndExec "\\ Installing EXT      " "sudo make install"
      displayAndExec "\\ Cleaning EXT        " "make clean && $PHP_INSTALL_FOLDER$PHP_70_FOLDER/bin/phpize --clean"
      #unset CFLAGS
      cd ../..
    elif [[ $D != *"ZendOptimizer"* ]]; then
      $PHP_INSTALL_FOLDER$PHP_70_FOLDER/bin/phpize 1>/dev/null
      displayAndExec "\\ Configuring $D      " "./configure --with-php-config=$PHP_INSTALL_FOLDER$PHP_70_FOLDER/bin/php-config"
      displayAndExec "\\ Bulding EXT         " "make -j $NB_CORE"
      displayAndExec "\\ Installing EXT      " "sudo make install"
      displayAndExec "\\ Cleaning EXT        " "make clean && $PHP_INSTALL_FOLDER$PHP_70_FOLDER/bin/phpize --clean"
    fi
    cd ..
  done

  cd ../..
fi

if [ "$ARG_START_PHP" = true ]; then
  displayAndExec "\\ Starting PHP 7.0.X      " "sudo service php-7.0-fpm start"
fi
