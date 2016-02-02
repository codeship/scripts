#!/bin/bash
# Install WebP Utilities to encode/decode WebP images https://developers.google.com/speed/webp/
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/webp.sh | bash -s

WEBP_VERSION=${WEBP_VERSION:="0.5.0"}
WEBP_DIR=${WEBP_DIR:="$HOME/webp"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/libwebp-${WEBP_VERSION}-linux-x86-64.tar.gz"

wget --no-check-certificate --continue --output-document "${CACHED_DOWNLOAD}" "https://downloads.webmproject.org/releases/webp/libwebp-${WEBP_VERSION}-linux-x86-64.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${WEBP_DIR}"
ln -s ${WEBP_DIR}/bin/* ${HOME}/bin
