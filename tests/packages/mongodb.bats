#!/usr/bin/env bats

setup() {
  rm -rf "${HOME}/cache/*"
	chmod u+x ./packages/mongodb.sh
}

teardown() {
	# kill the custom MongoDB instance and remove it's files
	kill $(cat "${HOME}/mongodb/mongod.lock")
	rm -rf "${HOME}/mongodb"
	rm -rf "${HOME}/cache/mongodb*"
}

@test "[mongodb.sh] Test default installation" {
	run ./packages/mongodb.sh
  [ "$status" -eq 0 ]
	[ -f "${HOME}/mongodb/" ]
	[ netstat -lnp | grep "27018.*mongod" ]
}

@test "[mongodb.sh] Test installing current version (3.4.4)" {
	run ./packages/mongodb.sh
	run bash -c "MONGODB_VERSION='3.4.4' ./packages/mongodb.sh"
  [ "$status" -eq 0 ]
	[ -f "${HOME}/mongodb/" ]
	[ netstat -lnp | grep "27018.*mongod" ]
}
