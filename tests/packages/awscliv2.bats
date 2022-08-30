#!/usr/bin/env bats

setup() {
  export AWSCLIV2_VERSION="latest"
}

@test "[awscliv2.sh] Script runs" {
  ./packages/awscliv2.sh
}

@test "[awscliv2.sh] Download cached" {
  [ -f "${HOME}/cache/awscli-exe-linux-x86_64.zip" ]
}

@test "[awscliv2.sh] Verify version 2.x installed" {
  run aws --version
  [[ "$output" =~ "aws-cli/2" ]]
}