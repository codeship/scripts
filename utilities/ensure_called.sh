#!/bin/bash
# Ensure a separate script is called in the event of an error
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/utilities/ensure_called.sh > ${HOME}/bin/ensure_called && chmod u+x ${HOME}/bin/ensure_called
#
# then use the script in your tests like
# ensure_called "test command to execute" [command2 ...] "on_exit handler"
COMMANDS=( "${@?$'\n'Usage: $0 command1 [command2 ...] exit_handler}" )
EXIT_HANDLER=${@: -1}

# remove the last element from the COMMANDS array (which is the exit_handler)
unset "COMMANDS[${#}-1]"

function on_exit() {
	local exit_code=$?
	echo -e "\e[33mRunning the exit handler (${EXIT_HANDLER})...\e[39m"
	${EXIT_HANDLER}
	echo -e "\e[33m... finished with exit code ${?}\e[39m"
	exit ${exit_code}
}
trap on_exit EXIT

set -e

for command in "${COMMANDS[@]}"; do
	${command}
done
