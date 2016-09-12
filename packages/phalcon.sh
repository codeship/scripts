#!/bin/bash
# Install Phalcon - https://phalconphp.com/en/
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/phalcon.sh | bash -s

set -e
CACHED_REPOSITORY="${HOME}/cache/cphalcon/"
CWD=$(pwd)
PHP_VERSION=$(phpenv version | grep -Eoe "([[:digit:]]+\.?)+")

# clone or update the repository
if [ ! -d "${CACHED_REPOSITORY}" ]; then
	git clone --depth=1 git://github.com/phalcon/cphalcon.git "${CACHED_REPOSITORY}" >/dev/null
else
	cd "${CACHED_REPOSITORY}"
	git pull origin master >/dev/null
fi

# compile and enable the extension
cd "${CACHED_REPOSITORY}/build"
./install >/dev/null
echo "extension=phalcon.so" >> "/home/rof/.phpenv/versions/${PHP_VERSION}/etc/php.ini"

cd "${CWD}"
