#!/usr/bin/env bats
DESCRIPTION_VERSION="3.2.11"
load redis_functions

setup() {
  export REDIS_VERSION="3.2.11"
}

@test "[redis.sh $DESCRIPTION_VERSION] Script runs" {
  ./packages/redis.sh
}

@test "[redis.sh $DESCRIPTION_VERSION] Download cached" {
  [ -f "${HOME}/cache/redis-${REDIS_VERSION}.tar.gz" ]
}

@test "[redis.sh $DESCRIPTION_VERSION] Compiled version cached" {
  [ -d "${HOME}/cache/redis-${REDIS_VERSION}" ]
}

@test "[redis.sh $DESCRIPTION_VERSION] Verify version" {
  run redis-server --version
  [[ "$output" =~ "Redis server v=${REDIS_VERSION}" ]]
}

@test "[redis.sh $DESCRIPTION_VERSION] Service is running" {
  run redis-cli ping
  [ "$output" = "PONG" ]
  cleanup
}
