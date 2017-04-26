#!/bin/bash
# Install Bats - https://github.com/sstephenson/bats
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/bats.sh | bash -s
BATS_VERSION="0.4.0"

set -e
CACHED_DOWNLOAD="${HOME}/cache/bats-${BATS_VERSION}.tar.gz"

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/sstephenson/bats/archive/v${BATS_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --directory "${HOME}"
mkdir -p "${HOME}/bats"
(
	cd "${HOME}/bats-${BATS_VERSION}"
	./install.sh "${HOME}/bats"
)
rm -rf "${HOME}/bats-${BATS_VERSION}"
ln -fs "${HOME}/bats/bin/bats" "${HOME}/bin/"

bats --version
