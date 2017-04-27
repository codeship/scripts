#!/bin/bash

set -e

echo "Installing Bats"
bash ./packages/bats.sh

echo "Running Caching Tests"
chmod u+x ./cache/*
bats --pretty ./tests/cache
