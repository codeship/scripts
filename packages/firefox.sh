#!/bin/sh
# Install a custom version of Firefox
#
# You can either add this here, or configure them on the environment tab of your
# project settings.
FIREFOX_VERSION="28.0"

set -e
CACHED_DOWNLOAD="${HOME}/cache/firefox-${FIREFOX_VERSION}.tar.bz2"

rm -rf "${HOME}/firefox"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2"
tar -xaf "${CACHED_DOWNLOAD}" --directory "${HOME}"
