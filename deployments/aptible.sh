#!/bin/bash
# Deploy to a Aptible, https://www.aptible.com/
#
# Add the following environment variables to your project configuration and add
# the public SSH key from your projects General settings page to
# https://dashboard.aptible.com/settings/ssh
# * APTIBLE_APP
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/deployments/aptible.sh | bash -s
APTIBLE_APP=${APTIBLE_APP:?'You need to configure the APTIBLE_APP environment variable!'}
git push "git@beta.aptible.com:${APTIBLE_APP}.git" "${CI_COMMIT_ID}:master"
