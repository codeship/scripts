#!/bin/bash
# Deploy to via pushing to a remote git repository.
#
# Add the following environment variables to your project configuration and add
# the public SSH key from your projects General settings page to
# https://dashboard.aptible.com/settings/ssh
# * REMOTE_REPOSITORY
# * REMOTE_BRANCH
#
# Include in your builds via
# https://raw.githubusercontent.com/codeship/scripts/master/deployments/git-push.sh | bash -s
${REMOTE_REPOSITORY:?'You need to configure the REMOTE_REPOSITORY environment variable!'}
${REMOTE_BRANCH:?'You need to configure the REMOTE_BRANCH environment variable!'}

set -e

git fetch --unshallow || true
git push ${REMOTE_REPOSITORY} ${CI_COMMIT_ID}:${REMOTE_BRANCH}
