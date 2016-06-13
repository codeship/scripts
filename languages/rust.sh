#!/bin/bash
# Install a custom Rust version, https://www.rust-lang.org
#
# The script install the latest stable version by default.
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/rust.sh)"
RUST_PATH=${RUST_PATH:=$HOME/rust}

curl -sSf https://static.rust-lang.org/rustup.sh | sh -s -- --disable-sudo --prefix="${RUST_PATH}"
export PATH="${RUST_PATH}/bin:${PATH}"
rustc --version
