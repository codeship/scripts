#!/bin/bash
# Install the latest Rust version - https://www.rust-lang.org
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/rust.sh)"

curl -sSf https://sh.rustup.rs | sh -s -- -y
# shellcheck source=/dev/null
source "${HOME}/.cargo/env"
rustc --version
