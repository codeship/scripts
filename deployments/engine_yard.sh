#!/bin/bash
# Deploy to Engine Yard via their CLI, https://www.engineyard.com/
#
# Add the following environment variables to your project configuration.
# * EY_API_TOKEN, e.g. "j4r82af4er9711a54d5a14c500783596cb35w20g"
# * EY_ENVIRONMENT, (optional)
# * EY_APP_URL, (optional, will be checked for a HTTP/2xx status code if provided
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/deployments/engine_yard.sh | bash -s

set -e

# Load RVM into a shell session *as a function* -- https://rvm.io/workflow/scripting
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
  false
fi

rvm use

EY_API_TOKEN=${EY_API_TOKEN:?'You need to configure the EY_API_TOKEN environment variable!'}
ENVIRONMENT_PARAMETER=${EY_ENVIRONMENT:+"--environment=$EY_ENVIRONMENT"}
CHECK_URL_COMMAND=${EY_APP_URL:+"check_url $EY_APP_URL"}

gem install engineyard --no-ri --no-rdoc
ey deploy --api-token="${EY_API_TOKEN}" -r "${CI_COMMIT_ID}" "${ENVIRONMENT_PARAMETER}"
${CHECK_URL_COMMAND}
