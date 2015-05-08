#!/bin/sh
# Deploy to a Aptible, https://www.aptible.com/
#
# Add this as an environment variable to your project configuration
APTIBLE_APP=""

git push git@beta.aptible.com:${APTIBLE_APP}.git ${CI_COMMIT_ID}:master
