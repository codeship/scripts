#!/bin/bash
# Install a custom geckodriver version - https://github.com/mozilla/geckodriver
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/geckodriver.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * GECKODRIVER_VERSION
#
GECKODRIVER_VERSION=${GECKODRIVER_VERSION:="0.19.1"}

set -e

CACHED_DOWNLOAD="${HOME}/cache/geckodriver-v${GECKODRIVER_VERSION}-linux64-precompiled.tar.gz"

rm -rf "${HOME}/bin/geckodriver"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/mozilla/geckodriver/releases/download/v${GECKODRIVER_VERSION}/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --directory "${HOME}/bin"

geckodriver --version | grep "${GECKODRIVER_VERSION}"
