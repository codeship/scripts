#!/bin/bash
# Deploy via envoyer.io
#
# Add the following environment variables to your project configuration.
# * ENVOYER_ID
#
# Include in your builds via
# https://raw.githubusercontent.com/codeship/scripts/master/deployments/envoyer.sh | bash -s
ENVOYER_ID=${ENVOYER_ID:?'You need to configure the ENVOYER_ID environment variable!'}
curl "https://envoyer.io/deploy/${ENVOYER_ID}"
