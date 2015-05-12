#!/bin/bash
# Install a custom version of PhantomJS, http://phantomjs.org/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * PHANTOMJS_VERSION
#
# Include in your builds via
# https://raw.githubusercontent.com/codeship/scripts/master/packages/phantomjs.sh | bash -s
PHANTOMJS_VERSION=${PHANTOMJS_VERSION:="1.9.8"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2"

# clean old version and setup directories
rm -rf ~/.phantomjs
mkdir ~/.phantomjs
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "~/.phantomjs"
