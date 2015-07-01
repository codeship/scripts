#!/bin/sh
# Adding deployment event to Rollbar
# https://rollbar.com/docs/deploys_other/
#
# You have to set the following environment variables in your project configuration
#
# * ROLLBAR_TOKEN
#
# You have the option to define the environment variables below, else defaults will be applied.
# For more details on Default Environment Variables (those starting with "CI_"), please visit:
# https://codeship.com/documentation/continuous-integration/set-environment-variables/
# 
# * ROLLBAR_ENVIRONMENT ( Default: 'production' )
# * ROLLBAR_REVISION ( Default: CI_COMMIT_ID )
# * ROLLBAR_LOCAL_USER ( Default: CI_COMMITTER_USERNAME )
# * ROLLBAR_COMMENT ( Default: CI_MESSAGE )
#
# Check required parameters
ROLLBAR_TOKEN=${ROLLBAR_TOKEN:?'You need to configure the ROLLBAR_TOKEN environment variable!'}
ROLLBAR_ENVIRONMENT=${ROLLBAR_ENVIRONMENT:-'production'}
ROLLBAR_REVISION=${ROLLBAR_REVISION:-$CI_COMMIT_ID}
ROLLBAR_LOCAL_USER=${ROLLBAR_LOCAL_USER:-$CI_COMMITTER_USERNAME}
ROLLBAR_COMMENT=${ROLLBAR_COMMENT:-$CI_MESSAGE}

#sanitize semicolons, remove newlines, and replace multiple spaces with a single space
ROLLBAR_ENVIRONMENT=$(echo ${ROLLBAR_ENVIRONMENT//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
ROLLBAR_REVISION=$(echo ${ROLLBAR_REVISION//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
ROLLBAR_LOCAL_USER=$(echo ${ROLLBAR_LOCAL_USER//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
ROLLBAR_COMMENT=$(echo ${ROLLBAR_COMMENT//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')

curl https://api.rollbar.com/api/1/deploy/ \
  -F access_token="${ROLLBAR_TOKEN}" \
  -F environment="${ROLLBAR_ENVIRONMENT}" \
  -F revision="${ROLLBAR_REVISION}" \
  -F local_username="${ROLLBAR_LOCAL_USER}" \
  -F comment="${ROLLBAR_COMMENT}"
