#!/bin/bash
# Install a custom CockroachDB version - https://www.cockroachlabs.com
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/cockroachdb.sh | bash -s
#
# Add the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * COCKROACHDB_VERSION
# * COCKROACHDB_PORT
#
COCKROACHDB_VERSION=${COCKROACHDB_VERSION:="1.1.2"}
COCKROACHDB_PORT=${COCKROACHDB_PORT:="26257"}

set -e
COCKROACHDB_DIR=${COCKROACHDB_DIR:="$HOME/cockroachdb"}
CACHED_DOWNLOAD="${HOME}/cache/cockroach-v${COCKROACHDB_VERSION}.linux-amd64.tgz"

mkdir -p "${COCKROACHDB_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://binaries.cockroachdb.com/cockroach-v${COCKROACHDB_VERSION}.linux-amd64.tgz"
tar -xf "${CACHED_DOWNLOAD}" --directory "${COCKROACHDB_DIR}"

ln -s "${COCKROACHDB_DIR}/cockroach-v${COCKROACHDB_VERSION}.linux-amd64/"* "${HOME}/bin"
bash -c "cockroach start --background --insecure --port ${COCKROACHDB_PORT} 2>&1 >/dev/null" >/dev/null & disown
cockroach version
