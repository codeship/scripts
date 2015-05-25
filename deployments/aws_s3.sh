#!/bin/bash
# Deploy to AWS S3, http://aws.amazon.com/s3/
#
# Add the following environment variables to your project configuration.
# * AWS_ACCESS_KEY_ID
# * AWS_SECRET_ACCESS_KEY
# * AWS_DEFAULT_REGION
# * AWS_S3_BUCKET
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/deployments/aws_s3.sh | bash -s
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:?'You need to configure the AWS_ACCESS_KEY_ID environment variable!'}
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:?'You need to configure the AWS_SECRET_ACCESS_KEY environment variable!'}
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:?'You need to configure the AWS_DEFAULT_REGION environment variable!'}
AWS_S3_BUCKET=${AWS_S3_BUCKET:?'You need to configure the AWS_S3_BUCKET environment variable!'}
LOCAL_PATH=${LOCAL_PATH:?'You need to configure the LOCAL_PATH environment variable!'}

# Fail the deployment on the first error
set -e

# install the AWS CLI, which isn't installed by default
pip install awscli

aws s3 cp "${LOCAL_PATH}" "s3://${AWS_S3_BUCKET}/"
