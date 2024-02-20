#!/bin/bash
# Install a custom ChromeDriver version, https://chromedriver.chromium.org/
# https://googlechromelabs.github.io/chrome-for-testing/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * CHROMEDRIVER_VERSION
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/chromedriver.sh | bash -s
CHROMEDRIVER_VERSION=${CHROMEDRIVER_VERSION:="122.0.6261.39"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/chromedriver-linux64-${CHROMEDRIVER_VERSION}.zip"

rm -rf "${HOME}/bin/chromedriver"
rm -rf "${HOME}/bin/chromedriver-linux64"

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://storage.googleapis.com/chrome-for-testing-public/${CHROMEDRIVER_VERSION}/linux64/chromedriver-linux64.zip"
unzip -o "${CACHED_DOWNLOAD}" -d "${HOME}/bin"
ln -s "${HOME}/bin/chromedriver-linux64/chromedriver" "${HOME}/bin/chromedriver"

chromedriver --version | grep "${CHROMEDRIVER_VERSION}"
