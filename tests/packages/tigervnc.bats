#!/usr/bin/env bats

setup() {
  export TIGERVNC_VERSION="1.8.0"
}

@test "[tigervnc.sh] Installs successfully" {
  run ./packages/tigervnc.sh
  [ "$status" -eq 0 ]
}

@test "[tigervnc.sh] Verify installed version" {
  run x0vncserver --version
  [ "$status" -eq 0 ]
  [[ "$output" =~ "TigerVNC Server version ${TIGERVNC_VERSION}" ]]
}
