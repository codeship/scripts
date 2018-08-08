#!/bin/bash
# Install a custom lftp version - https://lftp.yar.ru
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/lftp.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * LFTP_VERSION
#
LFTP_VERSION=${LFTP_VERSION:="4.8.4"}
LFTP_DIR=${LFTP_DIR:=$HOME/cache/lftp-$LFTP_VERSION}

set -e

if [ ! -d "${LFTP_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/lftp-${LFTP_VERSION}.tar.gz"

  mkdir -p "${HOME}/lftp"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "http://lftp.yar.ru/ftp/lftp-${LFTP_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/lftp"

  (
    cd "${HOME}/lftp" || exit 1
    ./configure --with-openssl=/usr/bin/openssl --prefix="${LFTP_DIR}"
    make
    make install
  )
fi

ln -s "${LFTP_DIR}/bin/"* "${HOME}/bin"
lftp --version | grep "${LFTP_VERSION}"
