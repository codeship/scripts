#!/bin/bash
# Deploy to a CloudFoundry compatible API endpoint.
#
# Add the following environment variables to your project configuration.
# * CF_API
# * CF_USER
# * CF_PASSWORD
# * CF_ORG
# * CF_SPACE
# * CF_APPLICATION
#
# Include in your builds via
# https://raw.githubusercontent.com/codeship/scripts/master/deployments/cloud_foundry.sh | bash -s
CF_API=${CF_API:?'You need to configure the CF_API environment variable!'}
CF_USER=${CF_USER:?'You need to configure the CF_USER environment variable!'}
CF_PASSWORD=${CF_PASSWORD:?'You need to configure the CF_PASSWORD environment variable!'}
CF_ORG=${CF_ORG:?'You need to configure the CF_ORG environment variable!'}
CF_SPACE=${CF_SPACE:?'You need to configure the CF_SPACE environment variable!'}
CF_APPLICATION=${CF_APPLICATION:?'You need to configure the CF_APPLICATION environment variable!'}

# Fail the deployment on the first error
set -e

cf api "${CF_API}"
cf auth "${CF_USER}" "${CF_PASSWORD}"
cf target -o "${CF_ORG}" -s "${CF_SPACE}"
cf push "${CF_APPLICATION}"
