#!/bin/bash
# Deploy to AWS ElasticBeanstalk, http://aws.amazon.com/elasticbeanstalk/
#
# Add the following environment variables to your project configuration.
# * AWS_ACCESS_KEY_ID
# * AWS_SECRET_ACCESS_KEY
# * AWS_APP_NAME
# * AWS_DEFAULT_REGION
# * AWS_S3_BUCKET (defaults to "${AWS_APP_NAME}_${CI_BRANCH}_deployment")
# * AWS_APP_ENVIRONMENT (defaults to "${CI_BRANCH}")
# * AWS_APP_VERSION (defaults to "${AWS_APP_ENVIRONMENT}_${CI_COMMIT_ID:0:8}_YYYY-mm-dd_HHMMSS")
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/deployments/aws_elastic_beanstalk.sh | bash -s
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?'You need to configure the AWS_ACCESS_KEY_ID environment variable!'}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?'You need to configure the AWS_SECRET_ACCESS_KEY environment variable!'}
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?'You need to configure the AWS_DEFAULT_REGION environment variable!'}
AWS_APP_NAME=${AWS_APP_NAME:?'You need to configure the AWS_APP_NAME environment variable!'}

# defaults
AWS_S3_BUCKET=${AWS_S3_BUCKET:=${AWS_APP_NAME}_${CI_BRANCH}_deployment}
AWS_APP_ENVIRONMENT=${AWS_APP_ENVIRONMENT:=${CI_BRANCH}}
AWS_APP_VERSION=${AWS_APP_VERSION:=${AWS_APP_ENVIRONMENT}_${COMMIT_ID:0:8}_$(date -u "+%Y-%m-%d_%H%M%S")}

# Fail the deployment on the first error
set -e

# install the AWS CLI, which isn't installed by default
pip install awscli

# if a config/database.yml file is available and it is part of the git repository
# reset it to the version saved in the repository.
if [ -e config/database.yml ] && [ $(git ls-files --error-unmatch config/database.yml 2>/dev/null) ]; then
	git checkout -- config/database.yml
fi

# create the archive and upload it to S3
zip -x \*/.git\* -x .git\* -x \*.hg\* -r "${DEPLOYMENT_ARCHIVE:=${HOME}/${AWS_APP_VERSION}.zip}" .
aws s3 cp "${DEPLOYMENT_ARCHIVE}" "s3://${AWS_S3_BUCKET}/${AWS_APP_VERSION:0:100}.zip"

# create the new version on ElasticBeanstalk
aws elasticbeanstalk create-application-version --application-name "${AWS_APP_NAME}" --version-label "${AWS_APP_VERSION:0:100}" --source-bundle "S3Bucket=${AWS_S3_BUCKET},S3Key=${AWS_APP_VERSION:0:100}.zip"
aws elasticbeanstalk update-environment --environment-name "${AWS_APP_ENVIRONMENT}" --version-label "${AWS_APP_VERSION:0:100}"

# check if the deployment was successful
eb_deployment_check "${AWS_APP_NAME}" "${AWS_APP_ENVIRONMENT}" "${AWS_APP_VERSION:0:100}"
