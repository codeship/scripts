#!/bin/bash
# Install a custom Ghostscript version - https://ghostscript.com
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/ghostscript.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * GHOSTSCRIPT_VERSION
#
GHOSTSCRIPT_VERSION=${GHOSTSCRIPT_VERSION:="9.20"}

set -e
GHOSTSCRIPT_DIR=${GHOSTSCRIPT_DIR:=$HOME/ghostscript}
CACHED_DOWNLOAD="${HOME}/cache/ghostscript-${GHOSTSCRIPT_VERSION}.tar.gz"

mkdir -p "${GHOSTSCRIPT_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs${GHOSTSCRIPT_VERSION//./}/ghostscript-${GHOSTSCRIPT_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${GHOSTSCRIPT_DIR}"

(
  cd "${GHOSTSCRIPT_DIR}" || exit 1
  ./configure --prefix="${HOME}"
  make
  make install
  ln -s "${HOME}/bin/gs" "${HOME}/bin/ghostscript"
)

ghostscript -version | grep "${GHOSTSCRIPT_VERSION}"
