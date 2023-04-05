#!/bin/bash
# Install a custom R version, https://www.r-project.org/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * R_VERSION
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/r.sh)"
R_VERSION=${R_VERSION:="3.5.2"}
R_PATH=${R_PATH:=$HOME/r}

CACHED_DOWNLOAD="${HOME}/cache/R-${R_VERSION}.tar.gz"
mkdir -p "${R_PATH}"

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://cran.r-project.org/src/base/R-${R_VERSION%%.*}/R-${R_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${R_PATH}"

(
  cd "${R_PATH}" || exit 1
  ./configure --without-recommended-packages
  make
)

export PATH="${R_PATH}/bin:${PATH}"

# check the correct version is yused
R --version | grep "${R_VERSION}"
