#!/usr/bin/env bats

setup() {
  export AWSCLIV2_VERSION="latest"
}

@test "[awscli.sh] Script runs" {
  ./packages/awscliv2.sh
}

@test "[awscli.sh] Download cached" {
  [ -f "${HOME}/cache/awscli-exe-linux-x86_64" ] # use regex to finsh the path for cached download
}

@test "[awscli.sh] Verify version 2.x installed" {
  run aws --version
  [[ "$output" =~ "aws-cli/2" ]]
}