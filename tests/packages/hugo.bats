#!/usr/bin/env bats

setup() {
  export HUGO_VERSION="0.81.0"
}

@test "[hugo.sh] Script runs" {
  ./packages/hugo.sh
}

@test "[hugo.sh] Verify installed version" {
  hugo version
}