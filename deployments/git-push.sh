#!/bin/sh
# Deploy to via pushing to a remote git repository.
#
# You can either add those here, or configure them on the environment tab of your
# project settings. Please make sure the remote is configured in a way you can
# push to, most likely you want to use a SSH based URL.
REMOTE="git@github.com:USER/REPOSITORY.git"
BRANCH="gh-pages"

# fetch the missing history
git fetch --unshallow || true

# push to the remote repository
git remote add codeship_push "${REMOTE}"
git push codeship_push "${COMMIT_ID}:refs/heads/${BRANCH}"
