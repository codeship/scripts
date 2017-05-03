#!/bin/bash
# Install a custom ElasticSearch version - https://www.elastic.co/products/elasticsearch
#
# To run this script in Codeship, add the following
# command to your project's test setup command:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/elasticsearch.sh | bash -s
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * ELASTICSEARCH_VERSION
# * ELASTICSEARCH_PORT
#
ELASTICSEARCH_VERSION=${ELASTICSEARCH_VERSION:="1.5.2"}
ELASTICSEARCH_PORT=${ELASTICSEARCH_PORT:="9333"}
ELASTICSEARCH_DIR=${ELASTICSEARCH_DIR:="$HOME/el"}

# The download location of version 5.x, and 2.x seems to follow a different URL structure to 1.x\
# Make sure to use Oracle JDK 8 for Elasticsearch 5.x run the following commands in your script.
# source $HOME/bin/jdk/jdk_switcher
# jdk_switcher home oraclejdk8
# jdk_switcher use oraclejdk8
if [ ${ELASTICSEARCH_VERSION:0:1} -eq 5 ]
then
  ELASTICSEARCH_DL_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"
elif [ ${ELASTICSEARCH_VERSION:0:1} -eq 2 ]
then
  ELASTICSEARCH_DL_URL="https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${ELASTICSEARCH_VERSION}/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"
else
  ELASTICSEARCH_DL_URL="https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"
fi
set -e

CACHED_DOWNLOAD="${HOME}/cache/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"

mkdir -p "${ELASTICSEARCH_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "${ELASTICSEARCH_DL_URL}"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${ELASTICSEARCH_DIR}"

echo "http.port: ${ELASTICSEARCH_PORT}" >> ${ELASTICSEARCH_DIR}/config/elasticsearch.yml

# Make sure to use the exact parameters you want for ElasticSearch
nohup bash -c "${ELASTICSEARCH_DIR}/bin/elasticsearch 2>&1" &
wget --retry-connrefused --tries=0 --waitretry=1 -O- -nv http://localhost:${ELASTICSEARCH_PORT}
