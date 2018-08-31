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
IMAGEMAGICK_VERSION=${IMAGEMAGICK_VERSION:="7.0.7-0"}
IMAGEMAGICK_DIR=${IMAGEMAGICK_DIR:=$HOME/cache/imagemagick-$IMAGEMAGICK_VERSION}

set -e

if [ ! -d "${IMAGEMAGICK_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz"

  mkdir -p "${HOME}/imagemagick"
  if  [[ ${IMAGEMAGICK_VERSION} == 6* ]];
  then
    wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/ImageMagick/ImageMagick6/archive/${IMAGEMAGICK_VERSION}.tar.gz"
  else
    wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/ImageMagick/ImageMagick/archive/${IMAGEMAGICK_VERSION}.tar.gz"
  fi
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/imagemagick"

  (
    cd "${HOME}/imagemagick" || exit 1
    ./configure --prefix="${IMAGEMAGICK_DIR}"
    make
    make install
  )
fi

ln -s "${IMAGEMAGICK_DIR}/bin/"* "${HOME}/bin"
identify -version | grep "${IMAGEMAGICK_VERSION}"
