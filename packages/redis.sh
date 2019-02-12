#!/bin/bash
# Install a custom Redis version - https://redis.io
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/redis.sh | bash -s
#
# Add the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * REDIS_VERSION
# * REDIS_PORT
#
REDIS_VERSION=${REDIS_VERSION:="4.0.12"}
REDIS_PORT=${REDIS_PORT:="6379"}
REDIS_CONF=${REDIS_CONF:=$HOME/redis/redis.conf}
REDIS_DIR=${REDIS_DIR:=$HOME/cache/redis-$REDIS_VERSION}

set -e

# Stop the default Redis instance
sudo /etc/init.d/redis-server stop

if [ ! -d "${REDIS_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/redis-${REDIS_VERSION}.tar.gz"

  mkdir -p "${HOME}/redis"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/redis"

  (
    cd "${HOME}/redis" || exit 1
    PREFIX="${REDIS_DIR}" make
    PREFIX="${REDIS_DIR}" make install
  )
fi

ln -s "${REDIS_DIR}/bin/"* "${HOME}/bin"
mkdir -p "${HOME}/redis"
sudo cp /etc/redis/redis.conf "${HOME}/redis"

sed -i 's+/var/run/redis/redis-server.pid+/home/rof/redis/redis-server.pid+' "${REDIS_CONF}"
sed -i 's+/var/log/redis/redis-server.log+/home/rof/redis/redis-server.log+' "${REDIS_CONF}"
sed -i 's+/var/lib/redis+/home/rof/redis+' "${REDIS_CONF}"

# Remove configuration items Redis 3 doesn't recognize
if [ ${REDIS_VERSION:0:1} -eq 3 ]
then
  sed -i '/always-show-logo yes/d' "${REDIS_CONF}"
  sed -i '/lazyfree-lazy-eviction no/d' "${REDIS_CONF}"
  sed -i '/lazyfree-lazy-expire no/d' "${REDIS_CONF}"
  sed -i '/lazyfree-lazy-server-del no/d' "${REDIS_CONF}"
  sed -i '/slave-lazy-flush no/d' "${REDIS_CONF}"
  sed -i '/aof-use-rdb-preamble no/d' "${REDIS_CONF}"
fi

bash -c "redis-server ${REDIS_CONF} 2>&1 >/dev/null" >/dev/null & disown
redis-server --version
