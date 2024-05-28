#!/usr/bin/env bats

setup() {
  export PHANTOMJS_VERSION="2.1.1"
}

@test "[phantomjs.sh] Script runs" {
  ./packages/phantomjs.sh
}

@test "[phantomjs.sh] Download cached" {
  [ -f "${HOME}/cache/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2" ]
}

@test "[phantomjs.sh] Verify installed version" {
  run phantomjs -v
  [[ "$output" == "${PHANTOMJS_VERSION}" ]]
}
