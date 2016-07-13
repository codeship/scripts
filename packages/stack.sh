#!/bin/bash
# Install the Haskell Tool Stack - http://haskellstack.org
#
# To run this script in Codeship, add the following command to your project's
# test setup command:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/stack.sh | bash -s
HASKELL_STACK_VERSION=${HASKELL_STACK_VERSION:="latest"}
HASKELL_STACK_DIR=${HASKELL_STACK:="$HOME/stack"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/stack-${HASKELL_STACK_VERSION}-linux-x86_64.tar.gz"

if [ ${HASKELL_STACK_VERSION} = "latest" ]
then
	rm -f "${CACHED_DOWNLOAD}"
  HASKELL_STACK_DOWNLOAD_URL="https://www.stackage.org/stack/linux-x86_64"
else
  HASKELL_STACK_DOWNLOAD_URL="https://github.com/commercialhaskell/stack/releases/download/v${HASKELL_STACK_VERSION}/stack-${HASKELL_STACK_VERSION}-linux-x86_64.tar.gz"
fi
set -e

mkdir -p "${HASKELL_STACK_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "${HASKELL_STACK_DOWNLOAD_URL}"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HASKELL_STACK_DIR}"

ln -s "${HASKELL_STACK_DIR}/stack" "${HOME}/bin/stack"
stack --version
