#!/bin/bash
# Install a custom Dart version, https://www.dartlang.org/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * DART_VERSION
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/dart.sh | bash -s
DART_VERSION=${DART_VERSION:="1.13.0"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/dart-${DART_VERSION}.zip"

rm -rf "${HOME}/dart-sdk"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip"
unzip -o "${CACHED_DOWNLOAD}" -d "${HOME}/"
