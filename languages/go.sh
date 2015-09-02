#!/bin/bash
# Install a custom Go version, https://golang.org/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * GO_VERSION
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/go.sh > ${HOME}/go.sh && source ${HOME}/go.sh
GO_VERSION=${GO_VERSION:="1.4.2"}

export GOROOT="/tmp/go${GO_VERSION}"

# no set -e because this file is sourced and with the option set a failing command
# would cause an infrastructur error message on Codeship.
CACHED_DOWNLOAD="${HOME}/cache/go${GO_VERSION}.linux-amd64.tar.gz"

mkdir -p "${GOROOT}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${GOROOT}"

# configure the new GOROOT and PATH
export PATH="${GOROOT}/bin:${PATH}"
