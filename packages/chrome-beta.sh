#!/bin/bash
# Install the latest Chrome Beta version, https://www.google.com/chrome/beta/
# Removes the pre-installed stable version of Chrome and replaces it with the beta version
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/chrome-beta.sh | bash -s

set -e

sudo dpkg -r google-chrome-stable
rm "${HOME}/bin/Chrome"
rm "${HOME}/bin/chrome"

wget https://dl.google.com/linux/direct/google-chrome-beta_current_amd64.deb
sudo dpkg -i google-chrome-beta_current_amd64.deb
rm google-chrome-beta_current_amd64.deb

ln -s "/opt/google/chrome-beta/chrome" "${HOME}/bin/Chrome"
ln -s "/opt/google/chrome-beta/chrome" "${HOME}/bin/chrome"

chrome --version
