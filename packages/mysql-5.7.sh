#!/bin/bash
# Install a custom MySQL 5.7 version - https://www.mysql.com
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/mysql-5.7.sh | bash -s
#
# Add the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * MYSQL_VERSION
# * MYSQL_PORT
#
MYSQL_VERSION=${MYSQL_VERSION:="5.7.17"}
MYSQL_PORT=${MYSQL_PORT:="3307"}

set -e
MYSQL_DIR=${MYSQL_DIR:=$HOME/mysql-$MYSQL_VERSION}
CACHED_DOWNLOAD="${HOME}/cache/mysql-${MYSQL_VERSION}-linux-glibc2.5-x86_64.tar.gz"

mkdir -p "${MYSQL_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-${MYSQL_VERSION}-linux-glibc2.5-x86_64.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${MYSQL_DIR}"
mkdir -p "${MYSQL_DIR}/data"
mkdir -p "${MYSQL_DIR}/socket"
mkdir -p "${MYSQL_DIR}/log"

echo "#
# The MySQL 5.7 database server configuration file.
#
[client]
port		= ${MYSQL_PORT}
socket		= ${MYSQL_DIR}/socket/mysqld.sock

# This was formally known as [safe_mysqld]. Both versions are currently parsed.
[mysqld_safe]
socket		= ${MYSQL_DIR}/socket/mysqld.sock
nice		= 0

[mysqld]
user		= rof
pid-file	= ${MYSQL_DIR}/mysqld.pid
socket		= ${MYSQL_DIR}/socket/mysqld.sock
port		= ${MYSQL_PORT}
basedir		= ${MYSQL_DIR}/data
datadir		= ${MYSQL_DIR}/data/mysql
tmpdir		= /tmp
lc-messages-dir	= ${MYSQL_DIR}/share/english
skip-external-locking

# Instead of skip-networking the default is now to listen only on
# localhost which is more compatible and is not less secure.
bind-address		= 127.0.0.1

# * Fine Tuning
max_allowed_packet	= 16M
thread_stack		= 192K
thread_cache_size	= 8

# * Query Cache Configuration
query_cache_limit	= 1M
query_cache_size        = 16M

# * Logging and Replication
log_error		= ${MYSQL_DIR}/log/error.log

[mysqldump]
quick
quote-names
max_allowed_packet	= 16M

[isamchk]
key_buffer		= 16M
" > "${MYSQL_DIR}/my.cnf"

"${MYSQL_DIR}/bin/mysqld" --defaults-file="${MYSQL_DIR}/my.cnf" --initialize-insecure

(
  cd "${MYSQL_DIR}" || exit 1
  ./bin/mysqld_safe --defaults-file="${MYSQL_DIR}/my.cnf" &
  sleep 10
)

"${MYSQL_DIR}/bin/mysql" --defaults-file="${MYSQL_DIR}/my.cnf" -u "${MYSQL_USER}" -e "SET PASSWORD FOR root@'localhost' = PASSWORD('${MYSQL_PASSWORD}');"
"${MYSQL_DIR}/bin/mysql" --defaults-file="${MYSQL_DIR}/my.cnf" --version | grep "${MYSQL_VERSION}"
