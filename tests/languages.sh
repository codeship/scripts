#!/bin/bash

set -e

# Dart
export DART_VERSION="1.22.1"
bash languages/dart.sh
dart --version 2>&1 | grep "${DART_VERSION}"

# Erlang
export ERLANG_VERSION="19.2"
source languages/erlang.sh
erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), erlang:display(erlang:binary_to_list(Version)), halt().' -noshell | grep "${ERLANG_VERSION}"

# Elixir, requires the Erlang script above
export ELIXIR_VERSION="1.4.2"
source languages/elixir.sh
elixir --version | grep "${ELIXIR_VERSION}"

# Go
export GO_VERSION="1.8"
source languages/go.sh
go version | grep "${GO_VERSION}"

# Python 2.*
export PYTHON_VERSION="2.7.13"
source languages/python.sh
python --version 2>&1 | grep "${PYTHON_VERSION}"

# Python 3.*
export PYTHON_VERSION="3.6.0"
source languages/python.sh
python --version 2>&1 | grep "${PYTHON_VERSION}"

# R
export R_VERSION="3.3.2"
source languages/r.sh
R --version | grep "${R_VERSION}"

# Rust
source languages/rust.sh
rustc --version
