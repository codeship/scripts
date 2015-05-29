#!/bin/sh
# Notify New Relic about a new deployment
# https://docs.newrelic.com/docs/apm/new-relic-apm/maintenance/setting-deployment-notifications#examples
#
# You have to set the following environment variables in your project configuration
# (NEW_RELIC_APP needs to match an existing Application Name in the New Relic APM)
#
# * NEW_RELIC_API_KEY
# * NEW_RELIC_APP 
#
# You have the option to define a revision, a description, and a changelog with the following environment variables
# (Defaults are: description = CI_MESSAGE, revision = CI_COMMIT_ID, and an empty changelog).
#
# * NEW_RELIC_DESCRIPTION  (65535 characters or less)
# * NEW_RELIC_REVISION  (127 characters or less)
# * NEW_RELIC_CHANGELOG  (65535 characters or less)
#
# Check required parameters
NEW_RELIC_API_KEY=${NEW_RELIC_API_KEY:?'You need to configure the NEW_RELIC_API_KEY environment variable!'}
NEW_RELIC_APP=${NEW_RELIC_APP:?'You need to configure the NEW_RELIC_APP environment variable!'}
NEW_RELIC_DESCRIPTION=${NEW_RELIC_DESCRIPTION:-$CI_MESSAGE}
NEW_RELIC_REVISION=${NEW_RELIC_REVISION:-$CI_COMMIT_ID}
NEW_RELIC_CHANGELOG=${NEW_RELIC_CHANGELOG:-}

#sanitize semicolons, remove newlines, and replace double (or more) spaces with a single space
NEW_RELIC_APP=$(echo ${NEW_RELIC_APP//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
NEW_RELIC_DESCRIPTION=$(echo ${NEW_RELIC_DESCRIPTION//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
NEW_RELIC_REVISION=$(echo ${NEW_RELIC_REVISION//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')
NEW_RELIC_CHANGELOG=$(echo ${NEW_RELIC_CHANGELOG//;/%3B}|sed ':a;N;$!ba;s/\n/ /g'|tr -s ' ')

curl https://api.newrelic.com/deployments.xml \
	-H "x-api-key:${NEW_RELIC_API_KEY}" \
	-d "deployment[app_name]=${NEW_RELIC_APP}" \
	-d "deployment[description]=${NEW_RELIC_DESCRIPTION}" \
	-d "deployment[revision]=${NEW_RELIC_REVISION}" \
	-d "deployment[changelog]=${NEW_RELIC_CHANGELOG}" \
	-d "deployment[user]=${CI_COMMITTER_USERNAME}"
