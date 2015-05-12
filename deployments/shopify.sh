#!/bin/bash
# Deploy to Shopify
#
# You can either add these here, or configure them in the environment variables
# section of your project settings.
# * SHOPIFY_API_KEY
# * SHOPIFY_API_PASSWORD
# * SHOPIFY_STORE_URL
# * SHOPIFY_THEME_ID (optional)
#
# Information about Shopify Theme Config Variables can be found here -
# https://github.com/hughker/shopify_theme#configuration
# You can leave off the SHOPIFY_THEME_ID if you'd like, just remember to remove it
# from the script before attempting to deploy.

# Include in your builds via
# https://raw.githubusercontent.com/codeship/scripts/master/deployments/shopify.sh | bash -s
SHOPIFY_API_KEY=${SHOPIFY_API_KEY:?'You need to configure the SHOPIFY_API_KEY environment variable!'}
SHOPIFY_API_PASSWORD=${SHOPIFY_API_PASSWORD:?'You need to configure the SHOPIFY_API_PASSWORD environment variable!'}
SHOPIFY_STORE_URL=${SHOPIFY_STORE_URL:?'You need to configure the SHOPIFY_STORE_URL environment variable!'}

set -e

gem install shopify_theme --no-ri --no-rdoc
theme configure "${SHOPIFY_API_KEY}" "${SHOPIFY_API_PASSWORD}" "${SHOPIFY_STORE_URL}" "${SHOPIFY_THEME_ID}"
git diff-tree -r --no-commit-id --name-only --diff-filter=ACMRT $COMMIT_ID | xargs theme upload
git diff-tree -r --no-commit-id --name-only --diff-filter=D $COMMIT_ID | xargs theme remove
