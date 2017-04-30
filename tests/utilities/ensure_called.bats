#!/usr/bin/env bats

setup() {
	chmod u+x ./utilities/ensure_called.sh
}

@test "[ensure_called.sh] Check with a single argument" {
	run "./utilities/ensure_called.sh 'echo Hello World'"
	[ "$status" -eq 0 ]
	[[ "$output" =~ "Hello World" ]]
	[[ "$output" =~ "Running the exit handler" ]]
}

@test "[ensure_called.sh] Check with no argument" {
	run "./utilities/ensure_called.sh"
	[ "$status" -ne 0 ]
}

@test "[ensure_called.sh] Check that the exit handler is called in case of an error" {
	run "./utilities/ensure_called.sh true false 'echo Hello World'"
	[ "$status" -eq 1 ]
	[[ "$output" =~ "Hello World" ]]
	[[ "$output" =~ "Running the exit handler" ]]
}

@test "[ensure_called.sh] Check commands are not run after a failing command" {
	run "./utilities/ensure_called.sh false 'echo Not Run' true"
	[ "$status" -eq 0 ]
	[[ ! "$output" =~ "Not Run" ]]
	[[ "$output" =~ "Running the exit handler" ]]
}
