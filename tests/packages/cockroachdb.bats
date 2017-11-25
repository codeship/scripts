#!/usr/bin/env bats

setup() {
  export COCKROACHDB_VERSION="1.1.2"
  export COCKROACHDB_PORT="26257"
}

@test "[cockroachdb.sh] Installs successfully" {
  rm -f "${HOME}/cache/cockroach-v${COCKROACHDB_VERSION}.linux-amd64.tgz"
  # https://github.com/sstephenson/bats/issues/80#issuecomment-174101686
  ./packages/cockroachdb.sh 3>-
  run cockroach version
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ "v${COCKROACHDB_VERSION}" ]]
}

@test "[cockroachdb.sh] Starts successfully" {
  sleep 3
  run bash -c "netstat -lnp | grep ${COCKROACHDB_PORT}"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "cockroach" ]]
}
