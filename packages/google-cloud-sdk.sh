#!/bin/bash
# Install the latest Google Cloud SDK version - https://cloud.google.com/sdk
#
# To run this script on Codeship, add the following
# command to your project's setup commands:
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/google-cloud-sdk.sh)"
#
# Add the following environment variables to your project configuration:
# * GOOGLE_CLOUD_KEY
#   * Set this variable to the contents of the "Service account key" JSON credentials file
#     downloaded from "APIs & Services > Credentials" in the Google Cloud Platform console.
#     You can safely copy-paste the entire contents of the file directly into the VALUE
#     field when configuring this environment variable.
# * GOOGLE_CLOUD_PROJECT_ID
#   * Set this variable to the value of the `project_id` property found in the above JSON file.

echo -e "\e[0;33mCodeship Basic now includes the gcloud CLI by default.\e[0m"
echo -e "\e[0;33mPlease see https://documentation.codeship.com/basic/continuous-deployment/deployment-with-gcloudcli and\e[0m"
echo -e "\e[0;33mhttps://documentation.codeship.com/basic/continuous-deployment/deployment-to-google-app-engine for more information.\e[0m"

GOOGLE_CLOUD_DIR=${GOOGLE_CLOUD_DIR:=$HOME/google-cloud-sdk}
GOOGLE_CLOUD_KEYFILE="${GOOGLE_CLOUD_DIR}/google-cloud-key.json"

export CLOUDSDK_PYTHON_SITEPACKAGES=1

gcloud --quiet components update
gcloud --quiet config set component_manager/disable_update_check true

# Authenticate with a service account
if [[ -z ${GOOGLE_CLOUD_KEY} || -z ${GOOGLE_CLOUD_PROJECT_ID} ]]; then
  echo -e "\e[0;33mWarning: Please make sure GOOGLE_CLOUD_KEY and GOOGLE_CLOUD_PROJECT_ID are set.\e[0m"
else
  echo "${GOOGLE_CLOUD_KEY}" > "${GOOGLE_CLOUD_KEYFILE}"
  gcloud auth activate-service-account --key-file "${GOOGLE_CLOUD_KEYFILE}" --project "${GOOGLE_CLOUD_PROJECT_ID}"
fi
