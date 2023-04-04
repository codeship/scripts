#!/bin/bash

debug() { echo -e "\033[0;37m$*\033[0m"; }
info() { echo -e "\033[0;36m$*\033[0m"; }
error() { >&2  echo -e "\033[0;31m$*\033[0m"; }
fail() { error ${1}; exit ${2:-1}; }

test_header() {
  echo -e "\n\n"
  info '#'
  info "# ${*}"
  info '#'
}

set -euo pipefail

# Dart
test_header "Dart"
export DART_VERSION="1.22.1"
bash languages/dart.sh
dart --version 2>&1 | grep "${DART_VERSION}"

# Elixir, requires the Erlang script above
test_header "Elixir"
export ELIXIR_VERSION="1.12.3"
source languages/elixir.sh
elixir --version | grep "${ELIXIR_VERSION}"

# Go
test_header "Go"
export GO_VERSION="1.20"
source languages/go.sh
go version | grep "${GO_VERSION}"

# R
test_header "R"
export R_VERSION="4.2.3"
source languages/r.sh
R --version | grep "${R_VERSION}"

# Rust
test_header "Rust"
source languages/rust.sh
rustc --version
