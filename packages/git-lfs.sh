#!/bin/sh
# Install git lfs - https://git-lfs.github.com/
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/git-lfs.sh | bash -s
GIT_LFS_VERSION="1.3.1"

set -e
GIT_LFS_DIR=${GIT_LFS_DIR:="$HOME/git-lfs"}
REPO_DIR=$(readlink -f "${HOME}/clone")
CACHED_DOWNLOAD="${HOME}/cache/git-lfs-linux-amd64-${GIT_LFS_VERSION}.tar.gz"

mkdir -p "${GIT_LFS_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/github/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-linux-amd64-${GIT_LFS_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${GIT_LFS_DIR}"

cd "${GIT_LFS_DIR}"
PREFIX=${HOME} ./install.sh
cd -

cd "${REPO_DIR}"
git lfs fetch
git lfs checkout
cd -

git lfs version | grep "git-lfs/${GIT_LFS_VERSION}"
