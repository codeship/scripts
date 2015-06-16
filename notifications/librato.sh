#!/bin/sh
# Adding deployment annotations to librato graphs
# http://support.metrics.librato.com/knowledgebase/articles/122410-adding-annotations-to-graphs
#
# You have to set the following environment variables in your project configuration
#
# * LIBRATO_USERID
# * LIBRATO_TOKEN
#
# You have the option to define the environment variables below, else defaults will be applied.
# For more details on Default Environment Variables (those starting with "CI_"), please visit:
# https://codeship.com/documentation/continuous-integration/set-environment-variables/
# 
# * LIBRATO_STREAM ( Default: "deployment" )
# * LIBRATO_TITLE ( Default: CI_COMMIT_ID )
# * LIBRATO_DESCRIPTION ( Default: CI_MESSAGE )
# * LIBRATO_SOURCE ( Default: CI_BRANCH )
# * LIBRATO_LINK_REL ( Default: CI_NAME )
# * LIBRATO_LINK_LABEL ( Default: CI_NAME )
# * LIBRATO_LINK_HREF ( Default: CI_BUILD_URL)
#
# Check required parameters
LIBRATO_USERID=${LIBRATO_USERID:?'You need to configure the LIBRATO_USERID environment variable!'}
LIBRATO_TOKEN=${LIBRATO_TOKEN:?'You need to configure the LIBRATO_TOKEN environment variable!'}
LIBRATO_STREAM=${LIBRATO_STREAM:-deployment}
LIBRATO_START_TIME=$(date +"%s")
LIBRATO_TITLE=${LIBRATO_TITLE:-$CI_COMMIT_ID}
LIBRATO_DESCRIPTION=${LIBRATO_DESCRIPTION:-$CI_MESSAGE}
LIBRATO_SOURCE=${LIBRATO_SOURCE:-$CI_BRANCH}
LIBRATO_LINK_REL=${LIBRATO_LINK_REL:-$CI_NAME}
LIBRATO_LINK_LABEL=${LIBRATO_LINK_LABEL:-$CI_NAME}
LIBRATO_LINK_HREF=${LIBRATO_LINK_HREF:-$CI_BUILD_URL}

#sanitize semicolons, remove newlines, and replace multiple spaces with a single space
LIBRATO_STREAM=$(echo ${LIBRATO_STREAM//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
LIBRATO_TITLE=$(echo ${LIBRATO_TITLE//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
LIBRATO_DESCRIPTION=$(echo ${LIBRATO_DESCRIPTION//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
LIBRATO_SOURCE=$(echo ${LIBRATO_SOURCE//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
LIBRATO_LINK_REL=$(echo ${LIBRATO_LINK_REL//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
LIBRATO_LINK_LABEL=$(echo ${LIBRATO_LINK_LABEL//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
LIBRATO_LINK_HREF=$(echo ${LIBRATO_LINK_HREF//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')

curl \
  -u ${LIBRATO_USERID}:${LIBRATO_TOKEN} \
  -d "start_time=${LIBRATO_START_TIME}" \
  -d "title=${LIBRATO_TITLE}" \
  -d "description=${LIBRATO_DESCRIPTION}" \
  -d "source=${LIBRATO_SOURCE}" \
  -d "links[0][rel]=${LIBRATO_LINK_REL}" \
  -d "links[0][label]=${LIBRATO_LINK_LABEL}" \
  -d "links[0][href]=${LIBRATO_LINK_HREF}" \
  -X POST https://metrics-api.librato.com/v1/annotations/${LIBRATO_STREAM}
