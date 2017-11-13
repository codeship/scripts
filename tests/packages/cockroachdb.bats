#!/usr/bin/env bats

setup() {
  export COCKROACHDB_VERSION="1.1.2"
}

@test "[cockroachdb.sh] Installs successfully" {
  rm -f "${HOME}/cache/cockroach-v${COCKROACHDB_VERSION}.linux-amd64.tgz"
  # https://github.com/sstephenson/bats/issues/80#issuecomment-174101686
  ./packages/cockroachdb.sh 3>-
  run cockroach version
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ "v${COCKROACHDB_VERSION}" ]]
}
