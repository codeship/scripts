#!/bin/sh
# Adding deployment event to Bugsnag
# http://notify.bugsnag.com/deploy
#
# You have to set the following environment variables in your project configuration
#
# * BUGSNAG_API_KEY
#
# You have the option to define the environment variables below, else defaults will be applied.
# For more details on Default Environment Variables (those starting with "CI_"), please visit:
# https://codeship.com/documentation/continuous-integration/set-environment-variables/
#
# * BUGSNAG_RELEASE_STAGE=development
#
# You can either add those here, or configure them on the environment tab of your
# project settings.
BUGSNAG_API_KEY=${BUGSNAG_API_KEY:?'You need to configure the BUGSNAG_API_KEY environment variable!'}
BUGSNAG_RELEASE_STAGE=${BUGSNAG_RELEASE_STAGE:-"production"}
BUGSNAG_BRANCH=$CI_BRANCH
BUGSNAG_REVISION=$CI_COMMIT_ID
BUGSNAG_REPOSITORY=$(git config --get remote.origin.url)

curl -d "apiKey=${BUGSNAG_API_KEY}&branch=${BUGSNAG_BRANCH}&repository=${BUGSNAG_REPOSITORY}&revision=${BUGSNAG_REVISION}&releaseStage=${BUGSNAG_RELEASE_STAGE}" http://notify.bugsnag.com/deploy
