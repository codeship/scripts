#!/bin/sh
# Install Hugo, https://gohugo.io/getting-started/installing/
#
# You can either add this here, or configure them on the environment tab of your
# project settings.
HUGO_VERSION="0.81.0"
HUGO_DIR=${HUGO_DIR:="$HOME/hugo"}
set -e
CACHED_DOWNLOAD="${HOME}/cache/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz"
mkdir -p "${HUGO_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz"
tar -xvf "${CACHED_DOWNLOAD}" --directory "${HUGO_DIR}"
ln -s "${HUGO_DIR}/hugo" "${HOME}/bin/hugo"
# check that everything worked
hugo version
