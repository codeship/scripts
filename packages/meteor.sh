#!/bin/bash
# Install Meteor, https://www.meteor.com
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/meteor.sh | bash -s
set -e
curl https://install.meteor.com > "${HOME}/install_meteor"
sed -i'' -e 's/PREFIX=.*/PREFIX="${HOME}"/g' "${HOME}/install_meteor"
bash "${HOME}/install_meteor"
