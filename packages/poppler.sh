#!/bin/bash
# Install a custom Poppler version - https://poppler.freedesktop.org
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/poppler.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * POPPLER_VERSION
#
POPPLER_VERSION=${POPPLER_VERSION:="0.52.0"}

set -e
POPPLER_DIR=${POPPLER_DIR:=$HOME/poppler}
CACHED_DOWNLOAD="${HOME}/cache/poppler-${POPPLER_VERSION}.tar.xz"

mkdir -p "${POPPLER_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://poppler.freedesktop.org/poppler-${POPPLER_VERSION}.tar.xz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${POPPLER_DIR}"

(
  cd "${POPPLER_DIR}" || exit 1
  ./configure --prefix="${HOME}"
  make
  make install
)

pdftotext -v 2>&1 | grep "${POPPLER_VERSION}"
