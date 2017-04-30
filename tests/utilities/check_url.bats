#!/usr/bin/env bats

setup() {
	chmod u+x ./utilities/check_url.sh
}

@test "[check_url.sh] Check valid URL https://codeship.com" {
	run ./utilities/check_url.sh -w 2 -t 2 "https://codeship.com"
	[ "$status" -eq 0 ]
	[[ "$output" =~ "Trying (1 of 2) 'wget --output-document=/dev/null -w 2 -t 2 https://codeship.com'" ]]
}

@test "[check_url.sh] Check invlid URL https://does_not_exist.codeship.com" {
	run ./utilities/check_url.sh -w 2 -t 2 "https://does_not_exist.codeship.com"
	[ "$status" -ne 0 ]
	[[ "$output" =~ "Trying (1 of 2) 'wget --output-document=/dev/null -w 2 -t 2 https://does_not_exist.codeship.com'" ]]
}

@test "[check_url.sh] Check certificate is not ignored by default" {
	run ./utilities/check_url.sh -w 2 -t 2 "https://cacert.org"
	[ "$status" -ne 0 ]
}

@test "[check_url.sh] Check certificate is ignored if '--no-check-certificate' is provided via WGET_OPTIONS environment variable" {
	run bash -c "WGET_OPTIONS='--no-check-certificate' ./utilities/check_url.sh -w 2 -t 2 https://cacert.org"
	[ "$status" -eq 0 ]
}
