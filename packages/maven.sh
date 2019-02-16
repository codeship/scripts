#!/bin/bash
# Install a custom Maven version - https://maven.apache.org
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/maven.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * MAVEN_VERSION
#
MAVEN_VERSION=${MAVEN_VERSION:="3.5.2"}
MAVEN_DIR=${MAVEN_DIR:=$HOME/cache/maven-$MAVEN_VERSION}

set -e

if [ ! -d "${MAVEN_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/apache-maven-${MAVEN_VERSION}.tar.gz"

  mkdir -p "${MAVEN_DIR}"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "https://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${MAVEN_DIR}"
fi

rm -rf "${HOME}/.maven"
mkdir -p "${HOME}/.maven/maven/bin"
ln -s "${MAVEN_DIR}/bin/"* "${HOME}/.maven/maven/bin"
mvn -v | grep "${MAVEN_VERSION}"
