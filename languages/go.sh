#!/bin/bash
# Install a custom Go version, https://golang.org/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * GO_VERSION
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/go.sh)" 
GO_VERSION=${GO_VERSION:="1.4.2"}

# strip all components from PATH which point toa GO installation and configure the
# download location
CLEANED_PATH=$(echo $PATH | sed -r 's|/(usr/local\|tmp)/go(/([0-9]\.)+[0-9])?/bin:||g')
CACHED_DOWNLOAD="${HOME}/cache/go${GO_VERSION}.linux-amd64.tar.gz"

# configure the new GOROOT and PATH
export GOROOT="/tmp/go/${GO_VERSION}"
export PATH="${GOROOT}/bin:${CLEANED_PATH}"

# no set -e because this file is sourced and with the option set a failing command
# would cause an infrastructur error message on Codeship.

mkdir -p "${GOROOT}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${GOROOT}"

# check the correct version is yused
go version | grep ${GO_VERSION}
