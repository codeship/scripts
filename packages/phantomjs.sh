#!/bin/bash
# Install a custom PhantomJS version - https://phantomjs.org/
#
# To run this script in Codeship, add the following
# command to your project's test setup command:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/phantomjs.sh | bash -s
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * PHANTOMJS_VERSION - Specify the version of PhantomJS
# * PHANTOMJS_HOST - Optional, specify the download location for the archive
#
# If you run into any rate limiting issues from Bitbucket, put the download
# file(s) into your own server and point to the location via the PHANTOMJS_HOST
# environment variable.
#
PHANTOMJS_VERSION=${PHANTOMJS_VERSION:="2.1.1"}
PHANTOMJS_HOST=${PHANTOMJS_HOST:="https://bitbucket.org/ariya/phantomjs/downloads"}

if [[ "${PHANTOMJS_HOST}" == "https://s3.amazonaws.com/codeship-packages" ]];
then
  echo "The Codeship mirror is no longer available, please use an alternative location"
  echo "PhantomJS 2.1.1 is installed by default"
  exit 1
fi

set -e
CACHED_DOWNLOAD="${HOME}/cache/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2"

# Remove old version and setup directories
rm -rf ~/.phantomjs
mkdir ~/.phantomjs
wget --continue --output-document "${CACHED_DOWNLOAD}" "${PHANTOMJS_HOST}/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/.phantomjs"
