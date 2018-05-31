#!/bin/bash
# Check the status of an ElasticBeanstalk deployment by checking both, environment
# health as well as the version the environment is running after the deployment.
#
# See http://docs.aws.amazon.com/cli/latest/reference/elasticbeanstalk/describe-environments.html
# for a description of the output of the "describe-environments" API call.
EB_APP_NAME=${1:?'You need to provide the Elastic Beanstalk application name'}
EB_ENV_NAME=${2:?'You need to provide the Elastic Beanstalk environment name'}
EB_ENV_VERSION=${3:?'You need to provide the version identifier that should be deployed'}

WAIT=10

function eb_describe_environment(){
  codeship_aws elasticbeanstalk describe-environments --application-name "${EB_APP_NAME}" --environment-names "${EB_ENV_NAME}"
}

echo -e "\033[0;36mWaiting for environment ${EB_ENV_NAME} to finish the deployment.\033[0m"
while  [ -z "${status}" ] || [ "${status}" == "Updating" ] || [ "${status}" == "Launching" ]; do
  echo -en '\033[0;37m.\033[0m'
  sleep ${WAIT}
  status=$(eb_describe_environment | jq -r '.Environments[0].Status')
done
echo -e "\033[0;36m\nDeployment for environment \"${EB_ENV_NAME}\" finished.\033[0m"

health=$(eb_describe_environment | jq -r '.Environments[0].Health')
if [ "${health}" == "Green" ] || [ "${health}" == "Yellow" ]; then
  echo -e "\033[0;32mEnvironment \"${EB_ENV_NAME}\" is ${health}.\033[0m"
else
  echo -e "\033[0;31mEnvironment \"${EB_ENV_NAME}\" is in an unhealthy state (\"${health}\").\033[0m"
  echo -e "\033[0;31mDeployment Failed.\033[0m"
  exit 1
fi

version=$(eb_describe_environment | jq -r '.Environments[0].VersionLabel')
if [ "${version}" == "${EB_ENV_VERSION}" ]; then
  echo -e "\033[0;32mEnvironment \"${EB_ENV_NAME}\" is now running version \"${version}\".\033[0m"
else
  echo -e "\033[0;31mEnvironment \"${EB_ENV_NAME}\" is running a different version (\"${version}\").\033[0m"
  echo -e "\033[0;31mDeployment Failed.\033[0m"
  exit 2
fi
