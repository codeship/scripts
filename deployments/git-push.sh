#!/bin/sh
# Deploy to via pushing to a remote git repository.
#
# You can either add those here, or configure them on the environment tab of your
# project settings. Please make sure the remote is configured in a way you can
# push to, most likely you want to use a SSH based URL.
USERNAME=""
EMAIL=""
REMOTE="git@github.com:USER/REPOSITORY.git"
BRANCH="gh-pages"
COMMIT_MESSAGE="Pushing from Codeship"

# basic git configuration
git config --global user.name "${USERNAME}"
git config --global user.email "${EMAIL}"

# fetch the missing history
git fetch --unshallow || true

# add the remote repository
git remote add codeship_push "${REMOTE}"

# checkout the branch and commit the changes
git checkout -b "${BRANCH}" "${REMOTE}/${BRANCH}"
git add -A .
git commit -m "${COMMIT_MESSAGE}"

# do the actual push
git push codeship_push "${BRANCH}"
