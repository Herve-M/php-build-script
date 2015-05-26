displayMessage "[PHP-5.4.X]"

if [ "$ARG_NEW_INSTALL" = true ]; then
  sudo mkdir -p /opt/PHP/5.4/{etc,var/log}
  sudo cp FILE/php/init.d/php-5.4-fpm /etc/init.d/
  sudo cp FILE/php/PHP/5.4/php-fpm.conf /etc/PHP/5.4/
  sudo cp FILE/php/PHP/5.4/php.ini /etc/PHP/5.4/
  cat >> /etc/fstab << EOI
  #PHP 5.4
  /etc/PHP/5.4 /opt/PHP/5.4/etc none bind 0 0
  /var/log/PHP/5.4 /opt/PHP/5.4/var/log none bind 0 0
EOI
fi

if [ "$ARG_REFRESH_EXT" != true ]; then
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
  displayAndExec "\\ Extract PHP archive     " "tar jxf SRC/PHP/$PHP_54_FILE --directory SRC/PHP/"

  #Build step
  folder=${PHP_54_FILE%.tar.bz2}
  cd SRC/PHP/$folder
  displayAndExec "\\ Configure PHP           " "$PHP_54_BCONF"
  displayAndExec "\\ Bulding PHP             " "make -j $NB_CORE"
  #Install step
  displayAndExec "\\ Shutting down PHP       " "sudo service php-5.4-fpm stop"
  displayAndExec "\\ Installing PHP          " "sudo make install"

  cd ../../..
fi

[ ! -x $PHP_INSTALL_FOLDER$PHP_54_FOLDER/bin/phpize ] && displayErrorAndExit 1 "Error : phpize for PHP 5.4 don't exist"

cd SRC/EXT/

#Ext step
for D in `find . -mindepth 1 -maxdepth 1 -type d`
do
  cd $D
  if [[ $D == *"cphalcon"* ]]
  then
    cd build/64bits
    #export CFLAGS="-O2 --fvisibility=hidden"
    $PHP_INSTALL_FOLDER$PHP_54_FOLDER/bin/phpize 1>/dev/null
    displayAndExec "\\ Configuring $D      " "./configure --enable-phalcon --with-php-config=$PHP_INSTALL_FOLDER$PHP_54_FOLDER/bin/php-config"
    displayAndExec "\\ Bulding EXT         " "make -j $NB_CORE"
    displayAndExec "\\ Installing EXT      " "sudo make install"
    displayAndExec "\\ Cleaning EXT        " "make clean && $PHP_INSTALL_FOLDER$PHP_54_FOLDER/bin/phpize --clean"
    #unset CFLAGS
    cd ../..
  else
    $PHP_INSTALL_FOLDER$PHP_54_FOLDER/bin/phpize 1>/dev/null
    displayAndExec "\\ Configuring $D      " "./configure --with-php-config=$PHP_INSTALL_FOLDER$PHP_54_FOLDER/bin/php-config"
    displayAndExec "\\ Bulding EXT         " "make -j $NB_CORE"
    displayAndExec "\\ Installing EXT      " "sudo make install"
    displayAndExec "\\ Cleaning EXT        " "make clean && $PHP_INSTALL_FOLDER$PHP_54_FOLDER/bin/phpize --clean"
  fi
  cd ..
done

cd ../..
