#!/usr/bin/env bats

setup() {
	chmod u+x ./utilities/random_timezone.sh
}

teardown() {
}

@test "Check certificate is not ignored by default" {
	run " source./utilities/random_timezone.sh"
	[ "$status" -eq 0 ]
	[[ "$output" =~ "Set TZ to:" ]]
	[[ $(echo ${TZ}) =~ "UTC" ]]
}
