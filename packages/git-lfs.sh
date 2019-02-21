#!/bin/sh
# Install git lfs - https://git-lfs.github.com/
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/git-lfs.sh | bash -s

# print a warning message if a user relies on the default version
# we are going to upgrade to 2.0.0 in the future
if [ -z ${GIT_LFS_VERSION} ]; then
        echo -e "\e[0;33mWarning: You are relying on the default version of Git LFS.\e[0m"
        echo -e "\e[0;33mWe will update this script to switch to version 2.0.0 in the near future, which will break support for the legacy API v0.5.0. Please either specify the GIT_LFS_VERSION environment variable or update your Git LFS server.\e[0m"
        echo -e "\e[0;33mPlease see https://github.com/git-lfs/git-lfs/releases/tag/v2.0.0 for more information.\e[0m"
fi
GIT_LFS_VERSION=${GIT_LFS_VERSION:="1.5.6"}

set -e
GIT_LFS_DIR=${GIT_LFS_DIR:="$HOME/git-lfs"}
REPO_DIR=$(readlink -f "${HOME}/clone")

DOWNLOAD_URL_PREFIX="git-lfs-linux-amd64-"
STRIP_COMPONENTS=1
if [ "${GIT_LFS_VERSION:0:1}" -ge 2 ] && [ "${GIT_LFS_VERSION:2:1}" -ge 5 ]; then
        DOWNLOAD_URL_PREFIX="git-lfs-linux-amd64-v"
        STRIP_COMPONENTS=0
fi

CACHED_DOWNLOAD="${HOME}/cache/${DOWNLOAD_URL_PREFIX}${GIT_LFS_VERSION}.tar.gz"
mkdir -p "${GIT_LFS_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/github/git-lfs/releases/download/v${GIT_LFS_VERSION}/${DOWNLOAD_URL_PREFIX}${GIT_LFS_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=${STRIP_COMPONENTS} --directory "${GIT_LFS_DIR}"

(
  cd "${GIT_LFS_DIR}" || exit 1
  PREFIX=${HOME} bash ./install.sh
)

(
  cd "${REPO_DIR}" || exit 1
  git lfs fetch
  git lfs checkout
)

git lfs version | grep "git-lfs/${GIT_LFS_VERSION}"
