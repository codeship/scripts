#!/bin/bash
# Install TigerVNC - http://tigervnc.org
#
# This script is meant to be run on Codeship during a SSH debug session
# To run this script during debug run the following command:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/tigervnc.sh | bash -s
#
# Set the following environment variable before running the script
# (otherwise the default below will be used).
# * TIGERVNC_VERSION
#
TIGERVNC_VERSION=${TIGERVNC_VERSION:="1.8.0"}

set -e

mkdir -p "${HOME}/tigervnc"
wget -O "tigervnc-${TIGERVNC_VERSION}.x86_64.tar.gz" "https://bintray.com/tigervnc/stable/download_file?file_path=tigervnc-${TIGERVNC_VERSION}.x86_64.tar.gz"
tar -xaf "tigervnc-${TIGERVNC_VERSION}.x86_64.tar.gz" --strip-components=1 --directory "${HOME}/tigervnc"

ln -s "${HOME}/tigervnc/usr/bin/"* "${HOME}/bin"
x0vncserver --version | grep "${TIGERVNC_VERSION}"
