#!/usr/bin/env bats

setup() {
	chmod u+x ./utilities/random_timezone.sh
	unset TZ
}

teardown() {
	export TZ="UTC"
}

@test "[random_timezone.sh] Check a (random) timzone is configured" {
	run source ./utilities/random_timezone.sh
	[ "$status" -eq 0 ]
	[[ "$output" =~ "Set TZ to:" ]]
	# check that the TZ environment variable is non-zero
	[ -n ${TZ} ]
}
