#!/usr/bin/env bats

setup() {
  mkdir -p "${HOME}/cache"
}

@test "[sdkman.sh] Installs successfully" {
  run source /dev/stdin <<< "$(cat ./packages/sdkman.sh)"
  [ "$status" -eq 0 ]
}

@test "[sdkman.sh] Initializes successfully" {
  run source $HOME/.sdkman/bin/sdkman-init.sh
  [ "$status" -eq 0 ]
}

@test "[sdkman.sh] Archives folder is replaced with symlink to cache" {
  run readlink $HOME/.sdkman/archives
  [ "$output" = "$HOME/cache/sdkman" ]
}
