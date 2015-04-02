#!/bin/sh
# Deploy Rails to Engine Yard via _engineyard_ gem
# https://github.com/engineyard/engineyard
#
# You can either add those here, or configure them on the environment tab of your
# project settings.
EY_ENVIRONMENT=""
EY_API_TOKEN=""
EY_APP_URL=""

gem install engineyard --no-ri --no-rdoc

ey deploy \
	-e "${EY_ENVIRONMENT}" \
	-r "${COMMIT_ID}" \
	--api-token "${EY_API_TOKEN}"
check_url "${EY_APP_URL}"
