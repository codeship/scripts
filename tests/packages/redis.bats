#!/usr/bin/env bats

setup() {
  export REDIS_VERSION="4.0.2"
}

@test "[redis.sh] Installs successfully" {
  skip "Work in progress"
  rm -f "${HOME}/cache/redis-${REDIS_VERSION}.tar.gz"
  rm -rf "${HOME}/cache/redis-${REDIS_VERSION}"
  # https://github.com/sstephenson/bats/issues/80#issuecomment-174101686
  ./packages/redis.sh 3>-
  run redis-server --version
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ "Redis server v=${REDIS_VERSION}" ]]
}
