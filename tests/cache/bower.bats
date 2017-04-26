#!/usr/bin/env bats

@test "bower" {
  run "./cache/bower.sh"
  [ "$status" -eq 0 ]
}
