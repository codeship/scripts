#!/bin/bash
# Install a custom git version - https://git-scm.com
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/git.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * GIT_VERSION
#
GIT_VERSION=${GIT_VERSION:="2.12.0"}
GIT_DIR=${GIT_DIR:=$HOME/cache/git-$GIT_VERSION}

set -e

if [ ! -d "${GIT_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/git-${GIT_VERSION}.tar.gz"

  mkdir -p "${HOME}/git"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/git/git/archive/v${GIT_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/git"

  (
    cd "${HOME}/git" || exit 1
    autoconf
    ./configure --prefix="${GIT_DIR}"
    make
    make install
  )
fi

ln -s "${GIT_DIR}/bin/"* "${HOME}/bin"
git --version | grep "${GIT_VERSION}"
