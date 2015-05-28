#!/bin/bash
# Install Gemnasium Toolbelt,  a CLI for the Gemnasium API. https://gemnasium.com
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/gemnasium.sh | bash -s
GEMNASIUM_VERSION=${GEMNASIUM_VERSION:="0.2.6"}
GEMNASIUM_DIR=${GEMNASIUM_DIR:="$HOME/gemnasium"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/gemnasium_${GEMNASIUM_VERSION}_linux_amd64.tar.gz"

mkdir -p "${GEMNASIUM_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/gemnasium/toolbelt/releases/download/${GEMNASIUM_VERSION}/gemnasium_${GEMNASIUM_VERSION}_linux_amd64.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${GEMNASIUM_DIR}"
ln -s "${GEMNASIUM_DIR}/gemnasium" ${HOME}/bin/
