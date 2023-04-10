#!/bin/bash
# Install and run BrowserStack Local, https://www.browserstack.com/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * BROWSERSTACK_ACCESS_KEY
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/browserstack_local.sh | bash -s
BROWSERSTACK_LOCAL_DIR=${BROWSERSTACK_LOCAL_DIR:="$HOME/.browserstack"}

# check required parameters
BROWSERSTACK_ACCESS_KEY=${BROWSERSTACK_ACCESS_KEY:?'You need to configure the BROWSERSTACK_ACCESS_KEY environment variable!'}

# exit on the first failure
set -e
CACHED_DOWNLOAD="${HOME}/.browserstack/BrowserStackLocal-linux-x64.zip"

mkdir -p "${BROWSERSTACK_LOCAL_DIR}"
rm -f "${BROWSERSTACK_LOCAL_DIR}/bstack_ready"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://www.browserstack.com/browserstack-local/BrowserStackLocal-linux-x64.zip"
unzip -o "${CACHED_DOWNLOAD}" -d "${BROWSERSTACK_LOCAL_DIR}"

${BROWSERSTACK_LOCAL_DIR}/BrowserStackLocal -k "${BROWSERSTACK_ACCESS_KEY}" >> "${BROWSERSTACK_LOCAL_DIR}/bstack_ready" &
while [ ! -e "${BROWSERSTACK_LOCAL_DIR}/bstack_ready" ]; do sleep 1; done

echo "BrowserStack Local is now ready..."
