#!/bin/sh

set -e

DIR="$(cd "$(dirname "${0}")" && pwd)"
cd "${DIR}"

function init_parallel() {
  mkdir -p "${HOME}/.parallel"
  touch "${HOME}/.parallel/ignored_vars"
}

function run_parallel() {
  local piped="$(cat -)"
  init_parallel
  parallel --dry-run "${1}" ::: ${piped}
  parallel --env _ --joblog - "${1}" ::: ${piped}
}

function run_all_scripts_in_dir_in_parallel() {
  ls "${1}" | run_parallel "bash ${1}/{}"
}

echo "Testing scripts for dependency caches"
run_all_scripts_in_dir_in_parallel "${DIR}/cache"

echo "Testing scripts for custom packages"
#run_all_scripts_in_dir_in_parallel "${DIR}/packages"
export SELENIUM_PORT=4444
bash packages/selenium_server.sh
netstat -lnp | grep "${SELENIUM_PORT}.*java"

export MONGODB_PORT=27018
bash packages/mongodb.sh
netstat -lnp | grep "${MONGODB_PORT}.*mongod"

bash packages/neo4j.sh
netstat -lnp | grep "7473.*java"
netstat -lnp | grep "7474.*java"

export FIREFOX_VERSION="40.0.2"
bash packages/firefox.sh
firefox --version | grep "${FIREFOX_VERSION}"

# Phalcon PHP framework
phpenv local 5.5
bash packages/phalcon.sh
php -m | grep phalcon
phpenv local 5.6
bash packages/phalcon.sh
php -m | grep phalcon

# Dart
export DART_VERSION="1.12.0"
bash packages/dart.sh
dart --version 2>&1 | grep "${DART_VERSION}"

# Solr
export SOLR_PORT="8983"
bash packages/solr.sh
netstat -lnp | grep "${SOLR_PORT}"

# JX framework
bash packages/jx.sh
jx --version

# git LFS
export GIT_LFS_VERSION="1.1.0"
bash packages/git-lfs.sh
git lfs env | grep "git-lfs/${GIT_LFS_VERSION}"

echo "Testing language scripts"
export GO_VERSION="1.4.2"
source languages/go.sh
go version | grep ${GO_VERSION}
export GO_VERSION="1.5"
source languages/go.sh
export GO_VERSION="1.6"
source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/go.sh)"
go version | grep ${GO_VERSION}
export GO_VERSION="1.4.2"
source languages/go.sh
go version | grep ${GO_VERSION}

echo "Testing utility scripts"
source utilities/random_timezone.sh

# test check_url
bash utilities/check_url.sh -w 2 -t 2 https://codeship.com
! bash utilities/check_url.sh -w 2 -t 2 https://does_not_exist.codeship.com

# test check_url certificate warnings
WGET_OPTIONS="--no-check-certificate" bash utilities/check_url.sh -w 2 -t 2 https://cacert.org
! bash utilities/check_url.sh -w 2 -t 2 https://cacert.org

# test ensure_called
bash utilities/ensure_called.sh "echo Hello World" | grep "Hello World"
bash utilities/ensure_called.sh true false "echo Hello World" | grep "Hello World"
! bash utilities/ensure_called.sh false "echo Not Run" true | grep "Not Run"
! bash utilities/ensure_called.sh
