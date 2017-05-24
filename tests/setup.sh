#!/bin/sh

debug() { echo "\033[0;37m$*\033[0m"; }
info() { echo "\033[0;36m$*\033[0m"; }
error() { >&2  echo "\033[0;31m$*\033[0m"; }
fail() { error ${1}; exit ${2:-1}; }

set -euo pipefail

# save the precompiled ShellCheck binary if it's available
# as we clear the dependency cache as part of the setup steps we either need to
# recompile the binary on each run, or move it
if [ -f "${HOME}/cache/shellcheck" ]; then
	info "Using cached ShellCheck binary"
	rm -rf "${HOME}/bin/shellcheck"
	cp  "${HOME}/cache/shellcheck" "${HOME}/bin/shellcheck"
fi

# install bats for running tests
info "Installing Bats"
bash packages/bats.sh

# clear the dependency cache
# this code can be deleted once all tests have been converted to bats format
# and take care of clearing their downloaded artifacts themselves.
info "Resetting the '${HOME}/cache' folder"
rm -rf "${HOME}/cache"
mkdir -p "${HOME}/cache/"

# install ShellCheck if it's not already available.
# we have to run this after clearing the cache, as otherwise the built binary
# won't be cached. we also have to make sure to not clear the complete cache
# in any of the tests.
if [ ! -f "${HOME}/bin/shellcheck" ]; then
	info "Installing ShellCheck"
	bash packages/shellcheck.sh 1>/dev/null
fi
