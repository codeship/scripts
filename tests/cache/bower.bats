#!/usr/bin/env bats

setup() {
  rm -rf "${HOME}/cache/*"
	chmod u+x ./cache/bower.sh
}

teardown() {
  rm -rf "./node_modules" "${HOME}/cache/*"
}

@test "[bower.sh] Configure caching bower packages" {
  run ./cache/bower.sh
  [ "$status" -eq 0 ]
	[ -f ${HOME}/.bowerrc ]
	[[ $(cat ${HOME}/.bowerrc | grep packages) =~ "${HOME}/cache" ]]
	[[ $(cat ${HOME}/.bowerrc | grep registry) =~ "${HOME}/cache" ]]
}

@test "[bower.sh] Check if bower is writing to the cache directory" {
	run bash -c "npm install bower && bower install jquery"
	[ "$status" -eq 0 ]
	[ $(du -s ${HOME}/cache/bower | cut -f 1) -ne 0 ]
	[[ $(bower cache list | grep jquery) =~ "jquery" ]]
}
