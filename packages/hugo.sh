#!/bin/sh
# Install a Hugo, https://gohugo.io/
#
# You can either add this here, or configure them on the environment tab of your
# project settings.
HUGO_VERSION="0.20"
HUGO_DIR=${HUGO_DIR:="$HOME/hugo"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/hugo_${HUGO_VERSION}_linux_amd64.tar.gz"

mkdir -p "${HUGO_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HUGO_DIR}"
ln -s "${HUGO_DIR}/hugo_${HUGO_VERSION}_linux_amd64" "${HOME}/bin/hugo"

# check that everything worked
hugo version
