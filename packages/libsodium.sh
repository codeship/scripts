#!/bin/bash
# Install a custom libsodium version - https://libsodium.org
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/libsodium.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * LIBSODIUM_VERSION
#
LIBSODIUM_VERSION=${LIBSODIUM_VERSION:="1.0.18"}
LIBSODIUM_DIR=${LIBSODIUM_DIR:=$HOME/cache/libsodium}

set -e

if [ ! -d "${LIBSODIUM_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/libsodium-${LIBSODIUM_VERSION}.tar.gz"

  mkdir -p "${HOME}/libsodium"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "https://download.libsodium.org/libsodium/releases/libsodium-${LIBSODIUM_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/libsodium"

  (
    cd "${HOME}/libsodium" || exit 1
    ./configure --prefix="${LIBSODIUM_DIR}"
    make
    make install
  )
fi
