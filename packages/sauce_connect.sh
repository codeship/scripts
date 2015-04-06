#!/bin/sh
# Install an run the Sauce Connect server, https://saucelabs.com/
#
# Add the following items as environment variables to your project configuration
# on Codeship.
SAUCE_USER=""
SAUCE_API_KEY=""
SAUCE_VERSION="4.3.6"

# exit on the first failure
set -e
SAUCE_DIR="${HOME}/sauce"
SAUCE_DOWNLOAD="${HOME}/cache/sc-${SAUCE_VERSION}-linux.tar.gz"

mkdir -p "${SAUCE_DIR}"
rm -f "${SAUCE_DIR}/sc_ready"

wget -O "${SAUCE_DOWNLOAD}" --continue "https://saucelabs.com/downloads/sc-${SAUCE_VERSION}-linux.tar.gz"
tar --strip-components=1 -C "${SAUCE_DIR}" -xzf "${SAUCE_DOWNLOAD}"

${SAUCE_DIR}/bin/sc -u "${SAUCE_USER}" -k "${SAUCE_API_KEY}" -f "${SAUCE_DIR}/sc_ready" 2>&1 &
while [ ! -e "${SAUCE_DIR}/sc_ready" ]; do sleep 1; done

echo "Sauce is now ready to connect..."
