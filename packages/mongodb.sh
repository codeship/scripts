#!/bin/bash
# Install a custom MongoDB version - https://www.mongodb.org/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * MONGODB_VERSION
# * MONGODB_PORT
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/mongodb.sh | bash -s
MONGODB_VERSION=${MONGODB_VERSION:="3.0.4"}
MONGODB_PORT=${MONGODB_PORT:="27018"}
MONGODB_DIR=${MONGODB_DIR:="$HOME/mongodb"}
MONGODB_WAIT_TIME=${MONGODB_WAIT_TIME:="10"}
MONGODB_START=${MONGODB_START:="Y"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/mongodb-linux-x86_64-ubuntu1404-${MONGODB_VERSION}.tgz"

mkdir -p "${MONGODB_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-${MONGODB_VERSION}.tgz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${MONGODB_DIR}"

# Allow users to opt out of starting MongoDB (ie: they just need the tools)
if [ $MONGODB_START = "Y" ]; then
  # Make sure to use the exact parameters you want for MongoDB and give it enough sleep time to properly start up
	nohup bash -c "LC_ALL=C ${MONGODB_DIR}/bin/mongod --port ${MONGODB_PORT} --dbpath ${MONGODB_DIR} 2>&1" &
	sleep "${MONGODB_WAIT_TIME}"
fi

