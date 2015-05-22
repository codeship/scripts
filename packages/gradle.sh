#!/bin/bash
# Install a custom Gradle version, https://gradle.org/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * GRADLE_VERSION
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/gradle.sh | bash -s
GRADLE_VERSION=${GRADLE_VERSION:="2.4"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/gradle-${GRADLE_VERSION}-bin.zip"

rm -rf "${HOME}/.gradle/gradle"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
unzip -o "${CACHED_DOWNLOAD}" -d "${HOME}/.gradle/"
ln -s "${HOME}/.gradle/gradle-${GRADLE_VERSION}/" "${HOME}/.gradle/gradle"
