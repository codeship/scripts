#!/usr/bin/env bats

setup() {
  export GECKODRIVER_VERSION="0.16.1"
}

@test "[geckodriver.sh] Installs successfully" {
  skip "Skip until this is compatible with latest Rust version"
  rm -f "${HOME}/cache/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"
  rm -rf "${HOME}/cache/geckodriver-${GECKODRIVER_VERSION}"
  source languages/rust.sh
  run ./packages/geckodriver.sh
  [ "$status" -eq 0 ]
}

@test "[geckodriver.sh] Verify installed version" {
  skip "Skip until this is compatible with latest Rust version"
  run geckodriver --version
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "geckodriver ${GECKODRIVER_VERSION}" ]
}
