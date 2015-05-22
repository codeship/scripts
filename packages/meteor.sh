#!/bin/bash
# Install Meteor, https://www.meteor.com
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/meteor.sh | bash -s
\curl -sSL https://install.meteor.com | sed -e 's/PREFIX=.*/PREFIX="${HOME}"/g' | sh
