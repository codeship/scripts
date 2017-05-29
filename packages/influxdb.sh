#!/bin/bash
# Install a custom Influxdb version - https://docs.influxdata.com/influxdb/v1.2/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * export INFLUX_VERSION=1.2.1
# * export INFLUX_DB=your_database
#

INFLUX_VERSION=${INFLUX_VERSION:="1.2.2"}
INFLUX_DIR=${INFLUX_DIR:="$HOME/influx"}
INFLUX_WAIT_TIME=${INFLUX_WAIT_TIME:="30"}
INFLUX_URL="https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUX_VERSION}_linux_amd64.tar.gz"
CACHED_DOWNLOAD="${HOME}/cache/influxdb-${INFLUX_VERSION}_linux_amd64.tar.gz"

mkdir -p "${INFLUX_DIR}"
set -e

wget --continue --output-document "${CACHED_DOWNLOAD}" "${INFLUX_URL}"
tar -xvf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${INFLUX_DIR}"

bash -c "${INFLUX_DIR}/influxdb-1.2.2-1/usr/bin/influxd 2>&1 >/dev/null" >/dev/null & disown
sleep "${INFLUX_WAIT_TIME}"

if [ "$INFLUX_DB" != "" ]
then
	bash -c "${INFLUX_DIR}/influxdb-1.2.2-1/usr/bin/influx -execute 'CREATE DATABASE $INFLUX_DB'"
else
	bash -c "${INFLUX_DIR}/influxdb-1.2.2-1/usr/bin/influx -execute 'CREATE DATABASE test'"
fi

bash -c "${INFLUX_DIR}/influxdb-1.2.2-1/usr/bin/influx -execute 'SHOW DATABASES'"
