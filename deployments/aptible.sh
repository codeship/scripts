#!/bin/sh
# Deploy to a Aptible, https://www.aptible.com/
#
# Before you use this script, add the public SSH key from your projects General
# settings page to https://dashboard.aptible.com/settings/ssh
#
# Add this as an environment variable to your project configuration
APTIBLE_APP=""

git push git@beta.aptible.com:${APTIBLE_APP}.git ${CI_COMMIT_ID}:master
