#!/bin/bash
# Install a custom Elixir version, http://elixir-lang.org/
#
# In most cases you'll need to also include the custom Erlang script from this
# repository (same folder) to install a suitable version of the Erlang VM.
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * ELIXIR_VERSION
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/elixir.sh)"
ELIXIR_VERSION=${ELIXIR_VERSION:="1.2.3"}
ELIXIR_PATH=${ELIXIR_PATH:=$HOME/elixir}
CACHED_DOWNLOAD="${HOME}/cache/elixir-v${ELIXIR_VERSION}.zip"

# no set -e because this file is sourced and with the option set a failing command
# would cause an infrastructur error message on Codeship.
mkdir -p "${ELIXIR_PATH}"

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://s3.amazonaws.com/s3.hex.pm/builds/elixir/v${ELIXIR_VERSION}.zip"
unzip -q -o "${CACHED_DOWNLOAD}" -d "${ELIXIR_PATH}"

export PATH="${ELIXIR_PATH}/bin:${PATH}"

# check the correct version is yused
elixir --version | grep "${ELIXIR_VERSION}"
