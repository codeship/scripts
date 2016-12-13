#!/bin/bash
# Install tomcat locally - https://tomcat.apache.org/index.html
#
# change the following environment variables to your project configuration as needed,
# otherwise the defaults below will be used.
# * TOMCAT_VERSION
#
# Include the following command your builds:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/tomcat.sh | bash -s

TOMCAT_VERSION=${TOMCAT_VERSION:="8.5.9"}
TOMCAT_DIR=${TOMCAT_DIR="$HOME/tomcat"}
TOMCAT_WAIT_TIME=${TOMCAT_WAIT_TIME:="10"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/apache-tomcat-${TOMCAT_VERSION}.tar.gz"

mkdir -p "${TOMCAT_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "http://www-us.apache.org/dist/tomcat/tomcat-${TOMCAT_VERSION:0:1}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${TOMCAT_DIR}"

# Make sure to use the exact parameters you want for Tomcat and give it enough sleep time to properly start up
bash ${TOMCAT_DIR}/bin/startup.sh
sleep ${TOMCAT_WAIT_TIME}
cd -

# check if tomcat successfully installs
bash tomcat/bin/version.sh | grep "Apache Tomcat/${TOMCAT_VERSION}"
