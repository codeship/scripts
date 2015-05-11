#!/bin/sh
# Install an run the Sauce Connect server, https://saucelabs.com/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * SAUCE_USER
# * SAUCE_API_KEY
#
# Include in your builds via
# https://raw.githubusercontent.com/codeship/scripts/master/packages/sauce_connect.sh | bash -s
SAUCE_VERSION=${SAUCE_VERSION:="4.3.8"}
SAUCE_DIR=${SAUCE_DIR:="$HOME/sc"}

# check required parameters
${SAUCE_USER:?'You need to configure the SAUCE_USER environment variable!'}
${SAUCE_API_KEY:?'You need to configure the SAUCE_API_KEY environment variable!'}

# exit on the first failure
set -e
CACHED_DOWNLOAD="${HOME}/cache/sc-${SAUCE_VERSION}-linux.tar.gz"

mkdir -p "${SAUCE_DIR}"
rm -f "${SAUCE_DIR}/sc_ready"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://saucelabs.com/downloads/sc-${SAUCE_VERSION}-linux.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${SAUCE_DIR}"

${SAUCE_DIR}/bin/sc -u "${SAUCE_USER}" -k "${SAUCE_API_KEY}" -f "${SAUCE_DIR}/sc_ready" 2>&1 &
while [ ! -e "${SAUCE_DIR}/sc_ready" ]; do sleep 1; done

echo "Sauce is now ready to connect..."
