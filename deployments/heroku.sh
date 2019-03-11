#!/bin/bash
# https://devcenter.heroku.com/articles/build-and-release-using-the-api
#
# To run this script on Codeship, add the following
# command as a custom deployment script:
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/deployments/heroku.sh | bash -s $HEROKU_APP_NAME
#
# Add the following environment variables to your project configuration:
# * HEROKU_APP_NAME
# * HEROKU_API_KEY
#
# If you need to deploy multiple Heroku apps you can setup multiple app name variables like
# HEROKU_APP_NAME_1 and HEROKU_APP_NAME_2 and then call the script twice passing in the different names

HEROKU_APP_NAME=${1:?'You need to provide your Heroku app name.'}
HEROKU_API_KEY=${HEROKU_API_KEY:?'Set the HEROKU_API_KEY environment variable. Get the key from https://dashboard.heroku.com/account'}

APPLICATION_FOLDER=$HOME/clone
AFTER_DEPLOYMENT_WAIT_TIME=${AFTER_DEPLOYMENT_WAIT_TIME:="10"}

echo "STARTING DEPLOYMENT"

function error_message() {
  echo -e "DEPLOYMENT FAILED on line $1 of the deployment script"
}

set -e

heroku apps:info "${HEROKU_APP_NAME}"
echo -e "\e[32mThe application \"${HEROKU_APP_NAME}\" can be accessed.\e[39m"

trap 'error_message $LINENO' ERR

set -o pipefail
set -e

echo "CHANGING Directory to $APPLICATION_FOLDER"
cd $APPLICATION_FOLDER

#echo "CHECKING Access to Heroku application $HEROKU_APP_NAME"
#codeship_heroku check_access $HEROKU_APP_NAME

ARTIFACT_PATH=/tmp/deployable_artifact.tar.gz

echo "PACKAGING tar.gz for deployment"
tar -pczf $ARTIFACT_PATH ./

echo "PREPARING Heroku source for upload"
sources=`curl -sS -X POST https://api.heroku.com/apps/$HEROKU_APP_NAME/sources -H 'Accept: application/vnd.heroku+json; version=3' -H "Authorization: Bearer $HEROKU_API_KEY"`

get_url=`echo $sources | jq -r .source_blob.get_url`
put_url=`echo $sources | jq -r .source_blob.put_url`

echo "UPLOADING tar.gz file to Heroku"
curl -sS -X PUT "$put_url" -H 'Content-Type:' --data-binary @$ARTIFACT_PATH

echo "STARTING Build process on Heroku"
deployment=`curl -sS -X POST https://api.heroku.com/apps/$HEROKU_APP_NAME/builds -d "{\"source_blob\":{\"url\":\"$get_url\", \"version\": \"$CI_COMMIT_ID\"}}" -H 'Accept: application/vnd.heroku+json; version=3' -H 'Content-Type: application/json' -H "Authorization: Bearer $HEROKU_API_KEY"`

deployment_id=`echo "$deployment" | jq -r .id`

echo "DEPLOYMENT: $deployment_id"

output_stream_url=`echo "$deployment" | jq -r .output_stream_url`

# Sleep to allow the output stream to become available
sleep $AFTER_DEPLOYMENT_WAIT_TIME

curl -sS "$output_stream_url"

# Sleep to allow Heroku to store the result of the deployment
sleep $AFTER_DEPLOYMENT_WAIT_TIME

echo "CHECKING API for deployment success"

deployment_result_json=`curl -sS https://api.heroku.com/apps/$HEROKU_APP_NAME/builds/$deployment_id -H 'Accept: application/vnd.heroku+json; version=3' -H "Authorization: Bearer $HEROKU_API_KEY"`

deployment_status=`echo "$deployment_result_json" | jq -r .status`
echo "DEPLOYMENT STATUS: $deployment_status"

[ "$deployment_status" = "succeeded" ]

echo "DEPLOYMENT SUCCESSFUL"
