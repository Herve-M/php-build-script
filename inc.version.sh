# Version
#-----------------------------------------------------------------------------

readonly MIRROR=http://ca1.php.net/get/FILE/from/this/mirror
readonly SIG_FILE_EXT=.asc

#PHP 5.4.X
readonly PHP_54_FILE=php-5.4.40.tar.bz2
readonly PHP_54_GPG_KEY=5DA04B5D
readonly PHP_54_GPG_FGP=F38252826ACD957EF380D39F2F7956BC5DA04B5D
readonly PHP_54_BCONG_FILE="BCONF/php5.4.shared.conf"
readonly PHP_54_BCONF=$( cat $PHP_54_BCONG_FILE)

#PHP 5.5.X
readonly PHP_55_FILE=php-5.5.24.tar.xz
readonly PHP_55_GPG_KEY=90D90EC1
readonly PHP_55_GPG_FGP=0BD78B5F97500D450838F95DFE857D9A90D90EC1
readonly PHP_55_BCONG_FILE="BCONF/php5.5.shared.conf"
readonly PHP_55_BCONF=$( cat $PHP_55_BCONG_FILE)

#PHP 5.6.X
readonly PHP_56_FILE=php-5.6.8.tar.xz
readonly PHP_56_GPG_KEY=33CFC8B3
readonly PHP_56_GPG_FGP=6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3
readonly PHP_56_BCONG_FILE="BCONF/php5.6.shared.conf"
readonly PHP_56_BCONF=$( cat $PHP_56_BCONG_FILE)

#Ext
#Only for PHP 5.4
readonly EXT_ZENDOPPLUS_URL=https://github.com/zendtech/ZendOptimizerPlus/archive/v7.0.5.tar.gz
#OnlyEnd
readonly EXT_GEOIP_URL=https://pecl.php.net/get/redis-2.2.7.tgz
readonly EXT_GMAGICK_URL=https://pecl.php.net/get/gmagick-1.1.7RC3.tgz
readonly EXT_IMAGICK_URL=https://pecl.php.net/get/imagick-3.3.0RC1.tgz
readonly EXT_GNUPG_URL=https://pecl.php.net/get/gnupg-1.3.6.tgz
readonly EXT_PHALCON_URL=https://github.com/phalcon/cphalcon/archive/phalcon-v2.0.0.tar.gz

EXTS[0]=$EXT_GEOIP_URL
EXTS[1]=$EXT_ZENDOPPLUS_URL
EXTS[2]=$EXT_GMAGICK_URL
EXTS[3]=$EXT_IMAGICK_URL
EXTS[4]=$EXT_GNUPG_URL
EXTS[5]=$EXT_PHALCON_URL
