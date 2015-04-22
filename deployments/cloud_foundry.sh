#!/bin/sh
# Deploy to a CloudFoundry compatible API
#
# You can either add those here, or configure them on the environment tab of your
# project settings.
CF_API=""
CF_USER=""
CF_PASSWORD=""
CF_ORG=""
CF_SPACE=""
CF_APPLICATION=""

# Fail the deployment on the first error
set -e

cf6 api "${CF_API}"
cf6 auth "${CF_USER}" "${CF_PASSWORD}"
cf6 target -o "${CF_ORG}" -s "${CF_SPACE}"
cf6 push "${CF_APPLICATION}"
