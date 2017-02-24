#!/bin/bash

set -e

echo "Installing ShellCheck"
bash packages/shellcheck.sh

echo "Running ShellCheck..."
echo "...on cache scripts"
shellcheck cache/*

echo "...on deployment scripts (PENDING)"
shellcheck deployments/* || true

echo "...on language scripts"
shellcheck languages/*

echo "...on notification scripts (PENDING)"
shellcheck notifications/* || true

echo "...on package scripts (PENDING)"
shellcheck packages/* || true

echo "...on utility scripts (PENDING)"
# Ignore SC1071: ShellCheck only supports sh/bash/ksh scripts
shellcheck -e SC1071 utilities/* || true
