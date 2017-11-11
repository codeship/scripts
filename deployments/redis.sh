#!/bin/bash
# Install a Redis local instance
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * REDIS_VERSION
# * REDIS_PORT
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/cockroachdb.sh | bash -s
REDIS_VERSION=${REDIS_VERSION:="4.0.2"}
REDIS_PORT=${REDIS_PORT:="26257"}
REDIS_DIR=${REDIS_DIR:="$HOME/redis"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/redis-${REDIS_VERSION}.tar.gz"

mkdir -p "${REDIS_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz"
tar -xf "${CACHED_DOWNLOAD}" --directory "${REDIS_DIR}"

# Make sure to use the exact parameters you want for DynamoDB and give it enough sleep time to properly start up
(
  cd ${REDIS_DIR}/redis-${REDIS_VERSION} || exit 1
	make
	src/redis-server --port ${REDIS_PORT} 2>&1 >/dev/null & disown
)
