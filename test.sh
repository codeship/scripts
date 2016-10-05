#!/bin/bash

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

echo "Installing ShellCheck"
bash packages/shellcheck.sh

echo "Running ShellCheck..."
echo "... on cache scripts"
shellcheck cache/*
echo "... on deployment scripts (PENDING)"
shellcheck deployments/* || true
echo "... on languages installation scripts"
shellcheck languages/*
echo "... on notification scripts (PENDING)"
shellcheck notifications/* || true
echo "... on package installation scripts (PENDING)"
shellcheck packages/* || true
echo "... on utilities cripts (PENDING)"
shellcheck utilities/* || true

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
phpenv local 5.6
bash packages/phalcon.sh
php -m | grep phalcon

# Dart
export DART_VERSION="1.12.0"
bash packages/dart.sh
dart --version 2>&1 | grep "${DART_VERSION}"

# git LFS
export GIT_LFS_VERSION="1.4.0"
bash packages/git-lfs.sh
git lfs version | grep "git-lfs/${GIT_LFS_VERSION}"

# ChromeDriver
export CHROMEDRIVER_VERSION="2.24"
bash packages/chromedriver.sh
chromedriver --version | grep "ChromeDriver ${CHROMEDRIVER_VERSION}"

# Haskell Stack
export HASKELL_STACK_VERSION="1.1.0"
bash packages/stack.sh
stack --version | grep "1.1.0"

# clear the symlink from the above installation
rm -rf "${HOME}/bin/stack"

export HASKELL_STACK_VERSION="latest"
bash packages/stack.sh
# latest version at the time of this code was written is 1.1.2
! stack --version | grep "1.1.0"

echo "Testing language scripts"
# Go Lang
export GO_VERSION="1.7"
source languages/go.sh
go version | grep ${GO_VERSION}

# Python
export PYTHON_VERSION="3.5.1"
source languages/python.sh
python --version | grep "${PYTHON_VERSION}"

# Erlang
export ERLANG_VERSION="18.3"
source languages/erlang.sh
erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), erlang:display(erlang:binary_to_list(Version)), halt().' -noshell | grep "${ERLANG_VERSION}"

# Elixir, requires the Erlang script above
export ELIXIR_VERSION="1.2.3"
source languages/elixir.sh
elixir --version | grep "${ELIXIR_VERSION}"

# Rust, default to the most recent stable version,
# doesn't support different versions (yet)
source languages/rust.sh
rustc --version

# R
export R_VERSION="3.3.0"
source languages/r.sh
R --version | grep "${R_VERSION}"


echo "Testing utility scripts"
source utilities/random_timezone.sh

# test check_url
bash utilities/check_url.sh -w 2 -t 2 https://codeship.com
! bash utilities/check_url.sh -w 2 -t 2 https://does_not_exist.codeship.com

# test check_url certificate warnings
WGET_OPTIONS="--no-check-certificate" bash utilities/check_url.sh -w 2 -t 2 https://cacert.org
! bash utilities/check_url.sh -w 2 -t 2 https://cacert.org

# test check_port
bash utilities/check_port.sh 3306
! bash utilities/check_port.sh 80

# test ensure_called
bash utilities/ensure_called.sh "echo Hello World" | grep "Hello World"
bash utilities/ensure_called.sh true false "echo Hello World" | grep "Hello World"
! bash utilities/ensure_called.sh false "echo Not Run" true | grep "Not Run"
! bash utilities/ensure_called.sh
