#!/bin/bash
# Install a custom Chrome version, https://www.google.com/chrome
# https://googlechromelabs.github.io/chrome-for-testing/
# Removes the pre-installed stable version of Chrome and replaces it with the specified version
# 
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * CHROME_VERSION
# 
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/chrome.sh | bash -s

CHROME_VERSION=${CHROME_VERSION:="122.0.6261.39"}
CACHED_DOWNLOAD="${HOME}/cache/chrome-linux64-${CHROME_VERSION}.zip"

set -e

sudo dpkg -r google-chrome-stable
rm "${HOME}/bin/Chrome"
rm "${HOME}/bin/chrome"

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-linux64.zip"
unzip -o "${CACHED_DOWNLOAD}" -d "${HOME}/bin"

ln -s "${HOME}/bin/chrome-linux64/chrome" "${HOME}/bin/Chrome"
ln -s "${HOME}/bin/chrome-linux64/chrome" "${HOME}/bin/chrome"

chrome --version
