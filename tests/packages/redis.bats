#!/usr/bin/env bats

teardown() {
  rm -f "${HOME}/bin/redis-"*
  rm -rf "${HOME}/redis"
  rm -rf "${HOME}/cache/redis-${REDIS_VERSION}"
  rm -f "${HOME}/cache/redis-${REDIS_VERSION}.tar.gz"
  unset REDIS_VERSION
}

@test "[redis.sh] Installs 4.0.2 successfully" {
  export REDIS_VERSION="4.0.2"
  # https://github.com/sstephenson/bats/issues/80#issuecomment-174101686
  ./packages/redis.sh 3>-

  run redis-server --version
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ "Redis server v=${REDIS_VERSION}" ]]

  run redis-cli ping
  [ "$status" -eq 0 ]
  [ "$output" = "PONG" ]
}

@test "[redis.sh] Installs 3.2.11 successfully" {
  export REDIS_VERSION="3.2.11"
  ./packages/redis.sh 3>-

  run redis-server --version
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ "Redis server v=${REDIS_VERSION}" ]]

  run redis-cli ping
  [ "$status" -eq 0 ]
  [ "$output" = "PONG" ]
}

@test "[redis.sh] Installs 2.8.24 successfully" {
  export REDIS_VERSION="2.8.24"
  ./packages/redis.sh 3>-

  run redis-server --version
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ "Redis server v=${REDIS_VERSION}" ]]

  run redis-cli ping
  [ "$status" -eq 0 ]
  [ "$output" = "PONG" ]
}
