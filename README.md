# PHP Build Scripts

## Installation

### Debian and Ubuntu based Linux distributions

```text
sudo apt-get install -y git-core
```

### Enterprise Linux and Fedora

**Fedora**  Install with:

```text
sudo yum install git
```

**Enterprise Linux** (RHEL and CentOS) Install with:

```text
sudo yum install git
```
### Windows

Not supported.

## Setup
To build all PHP versions (5.4 + 5.5 + 5.6) with extensions :
```
git clone https://github.com/Herve-M/php-build-script.git &&
cd php-build-script &&
./build.sh
```

## Commands

* `--install`           : Full install, create folder, syslink and build all PHP versions + Ext
* `--without-ext`       : Update all versions of PHP
* `--without-php`       : Update all extensions of all PHP versions
* `--update-php54`      : Update PHP 5.4
* `--update-php55`      : Update PHP 5.5
* `--update-php55`      : Update PHP 5.6
* `--update-php54-ext`  : Update PHP 5.4 extensions
* `--update-php55-ext`  : Update PHP 5.5 extensions
* `--update-php55-ext`  : Update PHP 5.6 extensions
* `--start-php`         : Start PHP after install
