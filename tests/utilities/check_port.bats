#!/usr/bin/env bats

setup() {
	chmod u+x ./utilities/check_port.sh
}

teardown() {
}

@test "[check_port.sh] Check open port 3306" {
	run "./utilities/check_port 3306"
	[ "$status" -eq 0 ]
}

@test "[check_port.sh] Check closed port 80" {
	run "./utilities/check_port 80"
	[ "$status" -eq 1 ]
	[ "$output" = "Service localhost:80 didn't become ready in time." ]
}
