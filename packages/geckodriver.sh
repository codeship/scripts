#!/bin/bash
# Install a custom geckodriver version - https://github.com/mozilla/geckodriver
#
# To run this script on Codeship, add the following
# commands to your project's setup commands:
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/rust.sh)"
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/geckodriver.sh | bash -s
#
# Add the following environment variable to your project configuration
# (otherwise the default below will be used).
# * GECKODRIVER_VERSION
#
GECKODRIVER_VERSION=${GECKODRIVER_VERSION:="0.16.1"}
GECKODRIVER_DIR=${GECKODRIVER_DIR:=$HOME/cache/geckodriver-$GECKODRIVER_VERSION}

set -e

if [ ! -d "${GECKODRIVER_DIR}" ]; then
  CACHED_DOWNLOAD="${HOME}/cache/geckodriver-v${GECKODRIVER_VERSION}-linux64.tar.gz"

  mkdir -p "${HOME}/geckodriver"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/mozilla/geckodriver/archive/v${GECKODRIVER_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${HOME}/geckodriver"

  (
    cd "${HOME}/geckodriver" || exit 1
    cargo build --release
    cp -r "${HOME}/geckodriver/target/release" "${GECKODRIVER_DIR}"
  )
fi

rm "${HOME}/bin/geckodriver"
ln -s "${GECKODRIVER_DIR}/geckodriver" "${HOME}/bin/geckodriver"
geckodriver --version | grep "${GECKODRIVER_VERSION}"
