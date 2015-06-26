#!/bin/sh
# Adding deployment events to DataDog stream
# http://docs.datadoghq.com/api/#events
#
# You have to set the following environment variables in your project configuration
#
# * DATADOG_API_KEY
#
# You have the option to define the environment variables below, else defaults will be applied.
# For more details on Default Environment Variables (those starting with "CI_"), please visit:
# https://codeship.com/documentation/continuous-integration/set-environment-variables/
# 
# * DATADOG_TITLE  ( Default: "Deployment" )
# * DATADOG_DESCRIPTION  ( Default: CI_MESSAGE )
# * DATADOG_PRIORITY  ( Default: "low" )
# * DATADOG_TAGS  ( Default: ["CI_NAME","commit:CI_COMMIT_ID","committer:CI_COMMITTER_USERNAME"] )
#
# Check required parameters
DATADOG_API_KEY=${DATADOG_API_KEY:?'You need to configure the DATADOG_API_KEY environment variable!'}
DATADOG_TITLE=${DATADOG_TITLE:-"Deployment"}
DATADOG_DESCRIPTION=${DATADOG_DESCRIPTION:-$CI_MESSAGE}
DATADOG_PRIORITY=${DATADOG_PRIORITY:-'low'}
DATADOG_TAGS=${DATADOG_TAGS:-"[\"CI_NAME\",\"commit:CI_COMMIT_ID\",\"committer:CI_COMMITTER_USERNAME\"]"}

#sanitize semicolons, remove newlines, and replace multiple spaces with a single space
DATADOG_TITLE=$(echo ${DATADOG_TITLE//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
DATADOG_DESCRIPTION=$(echo ${DATADOG_DESCRIPTION//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
DATADOG_PRIORITY=$(echo ${DATADOG_PRIORITY//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
DATADOG_TAGS=$(echo ${DATADOG_TAGS//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')

curl \
  -d "{
    \"title\": \"${DATADOG_TITLE}\",
    \"text\": \"${DATADOG_DESCRIPTION}\",
    \"priority\": \"${DATADOG_PRIORITY}\",
    \"tags\": ${DATADOG_TAGS}
  }" \
  -H 'Content-type: application/json' \
  -X POST https://app.datadoghq.com/api/v1/events?api_key=${DATADOG_API_KEY}
