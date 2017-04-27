#!/bin/sh

set -euo pipefail

# save the precompiled ShellCheck binary if it's available
# as we clear the dependency cache as part of the setup steps we either need to
# recompile the binary on each run, or move it
if [ -f "${HOME}/cache/shellcheck" ]; then
	rm -rf "${HOME}/bin/shellcheck"
	cp  "${HOME}/cache/shellcheck" "${HOME}/bin/shellcheck"
fi

# clear the dependency cache
rm -rf "${HOME}/cache"

# install bats for running tests
bash packages/bats.sh
