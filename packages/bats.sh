#!/bin/bash
# Install Bats - https://github.com/bats-core/bats-core
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/bats.sh | bash -s
BATS_VERSION="1.9.0"

set -e
CACHED_DOWNLOAD="${HOME}/cache/bats-core-${BATS_VERSION}.tar.gz"

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/bats-core/bats-core/archive/v${BATS_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --directory "${HOME}"
mkdir -p "${HOME}/bats"
(
  cd "${HOME}/bats-core-${BATS_VERSION}"
  ./install.sh "${HOME}/bats"
)
rm -rf "${HOME}/bats-core-${BATS_VERSION}"
ln -fs "${HOME}/bats/bin/bats" "${HOME}/bin/"

bats --version
