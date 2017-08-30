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

GOOGLE_CLOUD_DIR=${GOOGLE_CLOUD_DIR:=$HOME/google-cloud-sdk}
CACHED_DOWNLOAD="${HOME}/cache/google-cloud-sdk.tar.gz"
GOOGLE_CLOUD_KEYFILE="${GOOGLE_CLOUD_DIR}/google-cloud-key.json"

export CLOUDSDK_PYTHON_SITEPACKAGES=1
export PATH="${GOOGLE_CLOUD_DIR}/bin:${PATH}"

mkdir -p "${GOOGLE_CLOUD_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${GOOGLE_CLOUD_DIR}"

"${GOOGLE_CLOUD_DIR}/install.sh" --usage-reporting=false --path-update=true --bash-completion=true --rc-path="${HOME}/.bashrc" --disable-installation-options
gcloud --quiet components update
gcloud --quiet config set component_manager/disable_update_check true

# Authenticate with a service account
if [[ -z ${GOOGLE_CLOUD_KEY} || -z ${GOOGLE_CLOUD_PROJECT_ID} ]]; then
  echo -e "\e[0;33mWarning: Please make sure GOOGLE_CLOUD_KEY and GOOGLE_CLOUD_PROJECT_ID are set.\e[0m"
else
  echo "${GOOGLE_CLOUD_KEY}" > "${GOOGLE_CLOUD_KEYFILE}"
  gcloud auth activate-service-account --key-file "${GOOGLE_CLOUD_KEYFILE}" --project "${GOOGLE_CLOUD_PROJECT_ID}"
fi
