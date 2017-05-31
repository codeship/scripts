#!/bin/bash

debug() { echo -e "\033[0;37m$*\033[0m"; }
info() { echo -e "\033[0;36m$*\033[0m"; }
error() { >&2  echo -e "\033[0;31m$*\033[0m"; }
fail() { error ${1}; exit ${2:-1}; }

set -euo pipefail

info "Running ShellCheck..."
info "...on cache scripts"
shellcheck cache/*

info "...on deployment scripts (PENDING)"
shellcheck deployments/* || true

info "...on language scripts"
shellcheck languages/*

info "...on notification scripts (PENDING)"
shellcheck notifications/* || true

info "...on package scripts (PENDING)"
shellcheck packages/* || true

info "...on utility scripts (PENDING)"
# Ignore SC1071: ShellCheck only supports sh/bash/ksh scripts
shellcheck -e SC1071 utilities/* || true
