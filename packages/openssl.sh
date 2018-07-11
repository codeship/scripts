#!/bin/bash
# Install a custom OpenSSL version - https://www.openssl.org
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/openssl.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * OPENSSL_VERSION
#
OPENSSL_VERSION=${OPENSSL_VERSION:="1_0_2o"}
OPENSSL_DIR=${OPENSSL_DIR:=$HOME/cache/openssl}

set -e

if [ ! -d "${OPENSSL_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/openssl-${OPENSSL_VERSION}.tar.gz"

  mkdir -p "${HOME}/openssl"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/openssl/openssl/archive/OpenSSL_${OPENSSL_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/openssl"

  (
    cd "${HOME}/openssl" || exit 1
    ./config -fPIC shared --prefix="${OPENSSL_DIR}"
    make
    make install
  )
fi
