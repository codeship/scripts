#!/bin/bash
# Install ShellCheck - http://www.shellcheck.net/
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/shellcheck.sh | bash -s

set -e
CACHED_BINARY="${HOME}/cache/shellcheck"

if [ ! -f "${CACHED_BINARY}" ]; then
  cabal update
  cabal install ShellCheck --reinstall --force-reinstall
  mv "${HOME}/.cabal/bin/shellcheck" "${CACHED_BINARY}"
fi

ln -fs "${CACHED_BINARY}" "${HOME}/bin/"
shellcheck --version
