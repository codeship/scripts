#!/bin/bash
# Install a custom Erlang version, https://www.erlang.org/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * ERLANG_VERSION
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/erlang.sh)"
ERLANG_VERSION=${ERLANG_VERSION:="18.3"}
ERLANG_PATH=${ERLANG_PATH:=$HOME/erlang}
CACHED_DOWNLOAD="${HOME}/cache/erlang-OTP-${ERLANG_VERSION}.tar.gz"

# no set -e because this file is sourced and with the option set a failing command
# would cause an infrastructur error message on Codeship.
mkdir -p "${ERLANG_PATH}"
ERLANG_PATH=$(realpath "${ERLANG_PATH}")

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://s3.amazonaws.com/heroku-buildpack-elixir/erlang/cedar-14/OTP-${ERLANG_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${ERLANG_PATH}"
"${ERLANG_PATH}/Install" -minimal "${ERLANG_PATH}"

export PATH="${ERLANG_PATH}/bin:${PATH}"

# check the correct version is yused
erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), erlang:display(erlang:binary_to_list(Version)), halt().' -noshell | grep "${ERLANG_VERSION}"
