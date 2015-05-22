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

Not supported for now.

## Setup

```
git clone https://github.com/Herve-M/php-build-script.git &&
cd php-build-script &&
./build.sh
```

## Commands

* `--install` : Install PHP
* `--only-ext` : Only (re)build extentions and install it.
