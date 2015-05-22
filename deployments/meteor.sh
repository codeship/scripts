#!/bin/bash
# Deploy to a Meteor application, https://www.meteor.com
#
# This script expects meteor to be already installed and available in your path.
# Add the following environment variables to your project configuration
# * METEOR_SESSION
# * METEOR_USERNAME
# * METEOR_USER_ID
# * METEOR_TOKEN
# * METEOR_TOKEN_ID
# * METEOR_APP_URL
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/deployments/meteor.sh | bash -s
METEOR_SESSION=${METEOR_SESSION:?'You need to configure the METEOR_SESSION environment variable!'}
METEOR_USER_ID=${METEOR_USER_ID:?'You need to configure the METEOR_USER_ID environment variable!'}
METEOR_TOKEN=${METEOR_TOKEN:?'You need to configure the METEOR_TOKEN environment variable!'}
METEOR_APP_URL=${METEOR_APP_URL:?'You need to configure the METEOR_APP_URL environment variable!'}

set -e
cat <<EOF > "${HOME}/.meteorsession"
{
  "sessions": {
    "www.meteor.com": {
      "session": "${METEOR_SESSION}",
      "userId": "${METEOR_USER_ID}",
      "token": "${METEOR_TOKEN}"
    }
  }
}
EOF
meteor deploy "${METEOR_APP_URL}"
