#!/bin/bash
# Install a custom FreeTDS version - http://www.freetds.org
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/freetds.sh | bash -s
#
TDS_DIR=${TDS_DIR:=$HOME/cache/freetds}

set -e

if [ ! -d "${TDS_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/freetds.tar.gz"

  mkdir -p "${HOME}/freetds"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "ftp://ftp.freetds.org/pub/freetds/stable/freetds-patched.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/freetds"

  (
    cd "${HOME}/freetds" || exit 1
    ./configure --prefix="${TDS_DIR}"
    make
    make install
  )
fi

ln -s "${TDS_DIR}/bin/"* "${HOME}/bin"
