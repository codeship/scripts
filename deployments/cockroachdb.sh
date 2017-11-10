#!/bin/bash
# Install a CockroackDB local database
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * COCKROACHDB_VERSION
# * COCKROACHDB_PORT
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/cockroachdb.sh | bash -s
COCKROACHDB_VERSION=${DYNAMODB_VERSION:="latest"}
COCKROACHDB_PORT=${DYNAMODB_PORT:="26257"}
COCKROACHDB_DIR=${DYNAMODB_DIR:="$HOME/cockroackdb"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/cockroach-${COCKROACHDB_VERSION}.linux-amd64.tgz"

mkdir -p "${COCKROACHDB_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://binaries.cockroachdb.com/cockroach-${COCKROACHDB_VERSION}.linux-amd64.tgz"
tar -xf "${CACHED_DOWNLOAD}" --directory "${COCKROACHDB_DIR}"

# Make sure to use the exact parameters you want for DynamoDB and give it enough sleep time to properly start up
(
  cd ${COCKROACHDB_DIR} || exit 1
  cockroach-${COCKROACHDB_VERSION}.linux-amd64/cockroach --background --insecure --port ${COCKROACHDB_PORT}
)
