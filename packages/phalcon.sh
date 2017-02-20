#!/bin/bash
# Install Phalcon - https://phalconphp.com/en/
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/phalcon.sh | bash -s
PHALCON_VERSION=${PHALCON_VERSION:="3.0.3"}

set -e
CWD=$(pwd)
CACHED_DOWNLOAD="${HOME}/cache/cphalcon_v${PHALCON_VERSION}.tar.gz"
PHALCON_DIR=${PHALCON_DIR:="$HOME/phalcon"}
PHP_VERSION=$(phpenv version | grep -Eoe "([[:digit:]]+\.?)+")

mkdir -p "${PHALCON_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${PHALCON_DIR}"

# compile and enable the extension
cd "${PHALCON_DIR}/build"
./install >/dev/null
echo "extension=phalcon.so" >> "/home/rof/.phpenv/versions/${PHP_VERSION}/etc/php.ini"

cd "${CWD}"
php -m | grep phalcon
