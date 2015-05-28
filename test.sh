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

echo "Testing utility scripts"
source utilities/random_timezone.sh
bash utilities/check_url.sh https://codeship.com
! bash utilities/check_url.sh https://does_not_exist.codeship.com
