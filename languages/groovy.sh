#!/bin/bash
# Install groovy, http://www.groovy-lang.org/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * GROOVY_VERSION
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/groovy.sh)"
GROOVY_VERSION=${GROOVY_VERSION:="2.4.11"}
GROOVY_PATH=${GROOVY_PATH:=$HOME/groovy}
CACHED_DOWNLOAD="${HOME}/cache/groovy-v${GROOVY_VERSION}.zip"

mkdir -p "${GROOVY_PATH}"

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://bintray.com/artifact/download/groovy/maven/apache-groovy-binary-${GROOVY_VERSION}.zip"
unzip -q -o "${CACHED_DOWNLOAD}" -d "${GROOVY_PATH}"

# GROOVY_HOME environment variable required by groovy
export GROOVY_HOME="$GROOVY_PATH/groovy-$GROOVY_VERSION"
export PATH="${GROOVY_HOME}/bin:${PATH}"

# check the correct version is used
groovy --version | grep "${GROOVY_VERSION}"
