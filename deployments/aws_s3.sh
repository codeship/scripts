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

# Declare associative array of extra command line arguments for aws
# Supported only on bash v4
# Reference: http://docs.aws.amazon.com/cli/latest/reference/s3/cp.html
# Can be extended to include support for any of the available options in the aws cli
declare -A AWS_S3_EXTRA_ARGS=()

AWS_S3_EXTRA_ARGS["content-encoding"]=${AWS_S3_CONTENT_ENCODING} # Sets Content-Encoding Header
AWS_S3_EXTRA_ARGS["cache-control"]=${AWS_S3_CACHE_CONTROL} # Sets Cache-Control Header
AWS_S3_EXTRA_ARGS["acl"]=${AWS_S3_ACL} # Sets ACL


# Base command to be executed
BASE_COMMAND="aws s3 sync ${LOCAL_PATH} s3://${AWS_S3_BUCKET}/"

# Build command with arguments that are provided and not empty
for key in "${!AWS_S3_EXTRA_ARGS[@]}"
do
  if [ -n "${AWS_S3_EXTRA_ARGS[$key]}" ]; then # Checks if not empty
    echo "Detected AWS_S3 Argument: $key=\"${AWS_S3_EXTRA_ARGS[$key]}\""
    BASE_COMMAND+=" --$key=\"${AWS_S3_EXTRA_ARGS[$key]}\""
  fi
done

# Check for delete flag
if [ -n "${AWS_S3_DELETE_FLAG}" ]; then
	BASE_COMMAND+=" --delete"
fi

# Example Result
# LOCAL_PATH="build"
# AWS_S3_BUCKET="xyz"
# AWS_S3_CACHE_CONTROL="no-cache"
# AWS_DELETE_FLAG="1"
# aws s3 sync build s3://xyz/ --cache-control="no-cache" --delete

# Is eval unsafe ?
eval $BASE_COMMAND
