#!/bin/bash
# Install a custom RabbitMQ version - http://www.rabbitmq.com
#
# To run this script on Codeship, add the following
# commands to your project's setup commands:
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/erlang.sh)"
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/rabbitmq.sh | bash -s
#
# Add the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * RABBITMQ_VERSION
#
RABBITMQ_VERSION=${RABBITMQ_VERSION:="3.7.8"}

set -e
RABBITMQ_DIR=${RABBITMQ_DIR:=$HOME/rabbitmq-$RABBITMQ_VERSION}
CACHED_DOWNLOAD="${HOME}/cache/rabbitmq-${RABBITMQ_VERSION}.tar.xz"

# Stop the default RabbitMQ instance
sudo rabbitmqctl stop

mkdir -p "${RABBITMQ_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${RABBITMQ_VERSION}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${RABBITMQ_DIR}"

ln -s "${RABBITMQ_DIR}/sbin/"* "${HOME}/bin"
bash -c "rabbitmq-server -detached 2>&1 >/dev/null" >/dev/null & disown
sleep 5
rabbitmqctl status
