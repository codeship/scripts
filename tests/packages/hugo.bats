#!/usr/bin/env bats

setup() {
  export HUGO_VERSION="0.81.0"
}

@test "[hugo.sh] Script runs" {
  ./packages/hugo.sh
}

@test "[hugo.sh] Download cached" {
  [ -f "${HOME}/cache/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" ]
}

@test "[hugo.sh] Verify installed version" {
  hugo version
}