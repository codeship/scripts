#!/usr/bin/env bats

setup() {
  export GECKODRIVER_VERSION="0.19.1"
}

@test "[geckodriver.sh] Installs successfully" {
  rm -f "${HOME}/cache/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"
  run ./packages/geckodriver.sh
  [ "$status" -eq 0 ]
}

@test "[geckodriver.sh] Verify installed version" {
  run geckodriver --version
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "geckodriver ${GECKODRIVER_VERSION}" ]
}
