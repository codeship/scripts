#!/bin/bash

# The following script is pulling the binary files from the
# recommended mirror site. Visit http://www.apache.org/dyn/closer.lua/lucene/solr/
# for a full list of available mirrors.
#
# Remember to set the necessary version of Java. See
# https://codeship.com/documentation/languages/java-and-jvm-based-languages/
# for more information.
#
# To run this exact configuration and start solr, add the following to your builds:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/solr.sh | bash -s

# Set Java version
jdk_switcher home oraclejdk8
jdk_switcher use oraclejdk8

# Install solr
SOLR_VERSION=${SOLR_VERSION:="6.0.0"}
SOLR_MIRROR_URL=${SOLR_MIRROR_URL:="http://mirror.olnevhost.net/pub/apache/lucene/solr"}
CACHED_DOWNLOAD="${HOME}/cache/solr-${SOLR_VERSION}.zip"

rm -rf ~/.solr
mkdir ~/.solr

wget --continue --output-document "${CACHED_DOWNLOAD}" "${SOLR_MIRROR_URL}/${SOLR_VERSION}/solr-${SOLR_VERSION}.zip"
unzip -o "${CACHED_DOWNLOAD}" -d "${HOME}/.solr/"

# See https://cwiki.apache.org/confluence/display/solr/Solr+Start+Script+Reference
# for full reference to start, restart, and stop solr nodes
# Start solr on Codeship
${HOME}/.solr/solr-${SOLR_VERSION}/bin/solr start -e cloud -noprompt
