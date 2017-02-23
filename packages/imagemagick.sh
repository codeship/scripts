#!/bin/bash
# Install a custom ImageMagick version - https://www.imagemagick.org
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/imagemagick.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * IMAGEMAGICK_VERSION
#
IMAGEMAGICK_VERSION=${IMAGEMAGICK_VERSION:="7.0.5-0"}

set -e
IMAGEMAGICK_DIR=${IMAGEMAGICK_DIR:=$HOME/imagemagick}
CACHED_DOWNLOAD="${HOME}/cache/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz"

mkdir -p "${IMAGEMAGICK_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://www.imagemagick.org/download/releases/ImageMagick-${IMAGEMAGICK_VERSION}.tar.xz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${IMAGEMAGICK_DIR}"

(
  cd "${IMAGEMAGICK_DIR}" || exit 1
  ./configure --prefix="${HOME}"
  make
  make install
)

identify -version | grep "${IMAGEMAGICK_VERSION}"
