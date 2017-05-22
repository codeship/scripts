#!/bin/bash
# Install a custom version of Grails, https://grails.org
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * GRAILS_VERSION
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/grails.sh)"

GRAILS_VERSION=${GRAILS_VERSION:="3.2.9"}
GRAILS_PATH=${GRAILS_PATH:="$HOME/grails"}

CACHED_DOWNLOAD="${HOME}/cache/grails-v${GRAILS_VERSION}.zip"

mkdir -p ${GRAILS_PATH}
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/grails/grails-core/releases/download/v${GRAILS_VERSION}/grails-${GRAILS_VERSION}.zip"
unzip -q -o "${CACHED_DOWNLOAD}" -d "${GRAILS_PATH}"

export GRAILS_HOME="${GRAILS_PATH}/grails-${GRAILS_VERSION}"
export PATH="${GRAILS_HOME}/bin:${PATH}"

# check the correct version is used
grails --version | grep "${GRAILS_VERSION}"
