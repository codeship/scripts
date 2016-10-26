#!/bin/bash
# Install Meteor, https://www.meteor.com
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/meteor.sh | bash -s
# 
# Read your Meteor version via
# export METEOR_RELEASE=$(cat .meteor/release | sed "s/METEOR@//g")

METEOR_RELEASE=${METEOR_RELEASE:=""}
\curl -sSL https://install.meteor.com | if [[ $METEOR_RELEASE]]; then sed -i 's/^RELEASE=.*$/RELEASE="'${METEOR_RELEASE}'"/g' fi | sed -e 's/PREFIX=.*/PREFIX="${HOME}"/g' | sh
