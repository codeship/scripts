#!/bin/bash
# Install a custom QPDF version - http://qpdf.sourceforge.net
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/qpdf.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * QPDF_VERSION
#
QPDF_VERSION=${QPDF_VERSION:="8.3.0"}
QPDF_DIR=${QPDF_DIR:=$HOME/cache/qpdf-$QPDF_VERSION}

set -e

if [ ! -d "${QPDF_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/qpdf-${QPDF_VERSION}.tar.gz"

  mkdir -p "${HOME}/qpdf"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/qpdf/qpdf/archive/release-qpdf-${QPDF_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/qpdf"

  (
    cd "${HOME}/qpdf" || exit 1

    if [[ $(echo $QPDF_VERSION | awk -F '.' '{ print $1 }') -gt "7" ]]; then
      ./configure --prefix="${QPDF_DIR}"
    else
      ./autogen.sh
      ./configure --prefix="${QPDF_DIR}" --enable-doc-maintenance
    fi

    make
    make install
  )
fi

ln -s "${QPDF_DIR}/bin/"* "${HOME}/bin"
qpdf --version | grep "${QPDF_VERSION}"
