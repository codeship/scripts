#!/usr/bin/env bats

setup() {
	chmod u+x ./utilities/random_timezone.sh
	unset TZ
}

teardown() {
	export TZ="UTC"
}

@test "[random_timezone.sh] Check certificate is not ignored by default" {
	run source ./utilities/random_timezone.sh
	[ "$status" -eq 0 ]
	[[ "$output" =~ "Set TZ to:" ]]
	[[ $(echo ${TZ}) =~ "UTC" ]]
}
