#!/bin/sh
# Notify New Relic about a new deployment
# https://docs.newrelic.com/docs/apm/new-relic-apm/maintenance/setting-deployment-notifications#examples
#
# You can either add those here, or configure them on the environment tab of your
# project settings.
NEW_RELIC_API_KEY=""
NEW_RELIC_APP=""

curl https://api.newrelic.com/deployments.xml \
	-H "x-api-key:${NEW_RELIC_API_KEY}" \
	-d "deployment[app_name]=${NEW_RELIC_APP}" \
	-d "deployment[description]=${CI_MESSAGE}" \
	-d "deployment[revision]=${CI_COMMIT_ID}" \
	-d "deployment[user]=${CI_COMMITTER_USERNAME}"
