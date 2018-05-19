#!/bin/bash
# Install a custom FFmpeg version - https://ffmpeg.org
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/ffmpeg.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * FFMPEG_VERSION
#
FFMPEG_VERSION=${FFMPEG_VERSION:="4.0"}
FFMPEG_DIR=${FFMPEG_DIR:=$HOME/cache/ffmpeg-$FFMPEG_VERSION}

set -e

if [ ! -d "${FFMPEG_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/ffmpeg-${FFMPEG_VERSION}.tar.gz"

  mkdir -p "${HOME}/ffmpeg"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/FFmpeg/FFmpeg/archive/n${FFMPEG_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/ffmpeg"

  (
    cd "${HOME}/ffmpeg" || exit 1
    ./configure --prefix="${FFMPEG_DIR}" --disable-shared --enable-static --enable-gpl --enable-nonfree
    make
    make install
  )
fi

ln -s "${FFMPEG_DIR}/bin/"* "${HOME}/bin"
ffmpeg -version | grep "${FFMPEG_VERSION}"
