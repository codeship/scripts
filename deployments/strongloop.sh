#!/bin/bash
# Deploy to a Strongloop compatible API endpoint.
#
# Add the following environment variables to your project configuration.
# * SL_DEPLOY_URL
#
# Include in your builds via
SL_DEPLOY_URL=${SL_DEPLOY_URL:?'You need to configure the SL_DEPLOY_URL environment variable!'}

# Fail the deployment on the first error
set -e

nvm install 0.12.2
nvm use 0.12.2
npm install -g strong-build strong-deploy

sl-build -n
sl-deploy "${SL_DEPLOY_URL}"
