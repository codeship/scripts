#!/bin/sh
# Install the Google Cloud SDK
#
# You need to add the following environment variables to the environment tab on
# your project settings.
# * GOOGLE_CLOUD_KEY=""
# * GOOGLE_CLOUD_PROJECT_ID=""
# * CLOUDSDK_PYTHON_SITEPACKAGES=1
# * PATH="${HOME}/google-cloud-sdk/bin:${PATH}"

set -e
CACHED_DOWNLOAD="${HOME}/cache/google-cloud-sdk.tar.gz"
GOOGLE_CLOUD_KEYFILE="${HOME}/google-cloud-key.json"

# set configuration to make sure the installation works
export CLOUDSDK_PYTHON_SITEPACKAGES=1
export PATH="${HOME}/google-cloud-sdk/bin:${PATH}"

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --directory "${HOME}"
${HOME}/google-cloud-sdk/install.sh --usage-reporting false --rc-path "${HOME}/.bashrc" --bash-completion true --path-update true

# authenticate via a service account
echo "${GOOGLE_CLOUD_KEY}" > "${GOOGLE_CLOUD_KEYFILE}"
gcloud auth activate-service-account --key-file "${GOOGLE_CLOUD_KEYFILE}" --project "${GOOGLE_CLOUD_PROJECT_ID}"
