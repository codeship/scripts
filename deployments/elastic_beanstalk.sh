#!/bin/sh
# Deploy to AWS ElasticBeanstalk
#
# You can either add those here, or configure them on the environment tab of your
# project settings. The version must be unique for each deployment and should
# probably include at least the commit hash
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_DEFAULT_REGION=""
AWS_S3_BUCKET=""
AWS_APPLICATION_NAME=""
AWS_APPLICATION_ENVIRONMENT=""
AWS_APPLICATION_VERSION=""

set -e

# install the AWS CLI, which isn't installed by default
pip install awscli

# for rails projects only, reset the database configuration, which
# gets adapted for use on Codeship automatically
git checkout -- config/database.yml

# create the archive and upload it to S3
zip -x \*/.git\* -x .git\* -x \*.hg\* -r "${HOME}/aws_deployment_${AWS_APPLICATION_VERSION}.zip"
aws s3 cp "${HOME}/aws_deployment.zip" "s3://${AWS_S3_BUCKET}/subfolder/aws_deployment_${AWS_APPLICATION_VERSION}.zip"

# create the new version on ElasticBeanstalk
aws elasticbeanstalk create-application-version --application-name "${AWS_APPLICATION_NAME}" --version-label "${AWS_APPLICATION_VERSION}" --source-bundle S3Bucket="${AWS_S3_BUCKET}",S3Key="subfolder/aws_deployment_${AWS_APPLICATION_VERSION}.zip"
aws elasticbeanstalk update-environment --environment-name "${AWS_APPLICATION_ENVIRONMENT}" --version-label "${AWS_APPLICATION_VERSION}"

# check if the deployment was successful
eb_deployment_check "${AWS_APPLICATION_NAME}" "${AWS_APPLICATION_ENVIRONMENT}"
