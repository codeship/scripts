#!/bin/sh
# Install a custom ElasticSearch version - https://www.elastic.co/products/elasticsearch
#
# Add at least the following environment variables to your project configuration
# (otherwise) the defaults below will be used
# * ELASTICSEARCH_VERSION
# * ELASTICSEARCH_PORT
#
# Include in your builds via
# https://raw.githubusercontent.com/codeship/scripts/master/packages/elasticsearch.sh | bash -s
ELASTICSEARCH_VERSION=${ELASTICSEARCH_VERSION:="1.5.1"}
ELASTICSEARCH_PORT=${ELASTICSEARCH_PORT:="9333"}
ELASTICSEARCH_DIR=${ELASTICSEARCH_DIR:="$HOME/el"}
ELASTICSEARCH_WAIT_TIME=${ELASTICSEARCH_WAIT_TIME:="30"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"

mkdir -p "${ELASTICSEARCH_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${ELASTICSEARCH_DIR}"

echo "http.port: ${ELASTICSEARCH_PORT}" >> ${ELASTICSEARCH_DIR}/config/elasticsearch.yml

# Make sure to use the exact parameters you want for ElasticSearch and give it enough sleep time to properly start up
nohup bash -c "${ELASTICSEARCH_DIR}/bin/elasticsearch 2>&1" &
sleep "${ELASTICSEARCH_WAIT_TIME}"
