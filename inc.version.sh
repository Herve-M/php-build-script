# Version
#-----------------------------------------------------------------------------

readonly MIRROR=http://php.net/get/FILE/from/this/mirror
readonly SIG_FILE_EXT=.asc

readonly PHP_INSTALL_FOLDER=/opt/PHP/

#PHP 5.5.X
readonly PHP_55_FILE=php-5.5.34.tar.xz
readonly PHP_55_GPG_KEY=90D90EC1
readonly PHP_55_GPG_FGP=0BD78B5F97500D450838F95DFE857D9A90D90EC1
readonly PHP_55_BCONG_FILE="BCONF/php5.5.shared.conf"
readonly PHP_55_BCONF=$( cat $PHP_55_BCONG_FILE)
readonly PHP_55_FOLDER=5.5

#PHP 5.6.X
readonly PHP_56_FILE=php-5.6.20.tar.xz
readonly PHP_56_GPG_KEY=33CFC8B3
readonly PHP_56_GPG_FGP=6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3
readonly PHP_56_BCONG_FILE="BCONF/php5.6.shared.conf"
readonly PHP_56_BCONF=$( cat $PHP_56_BCONG_FILE)
readonly PHP_56_FOLDER=5.6

#PHP 5.7.X
readonly PHP_70_FILE=php-7.0.5.tar.xz
readonly PHP_70_GPG_KEY=9C0D5763
readonly PHP_70_GPG_FGP=1A4E8B7277C42E53DBA9C7B9BCAA30EA9C0D5763
readonly PHP_70_BCONG_FILE="BCONF/php7.0.shared.conf"
readonly PHP_70_BCONF=$( cat $PHP_70_BCONG_FILE)
readonly PHP_70_FOLDER=7.0

#Ext
readonly EXT_GEOIP_URL=https://pecl.php.net/get/geoip-1.1.0.tgz
readonly EXT_GMAGICK_URL=https://pecl.php.net/get/gmagick-2.0.2RC2.tgz
readonly EXT_IMAGICK_URL=https://pecl.php.net/get/imagick-3.4.1.tgz
readonly EXT_GNUPG_URL=https://pecl.php.net/get/gnupg-1.3.6.tgz
readonly EXT_PHALCON_URL=https://github.com/phalcon/cphalcon/archive/phalcon-v2.0.10.tar.gz

EXTS[0]=$EXT_GEOIP_URL
EXTS[1]=$EXT_GMAGICK_URL
EXTS[2]=$EXT_IMAGICK_URL
EXTS[3]=$EXT_GNUPG_URL
EXTS[4]=$EXT_PHALCON_URL
