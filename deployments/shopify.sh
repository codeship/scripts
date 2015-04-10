#!/bin/sh
# Deploy to Shopify
#
# You can either add these here, or configure them in the environment variables
# section of your project settings. Information about Shopify Theme Config Variables
# can be found here - https://github.com/hughker/shopify_theme#configuration
# You can leave off the SHOPIFY_THEME_ID if you'd like, just remember to remove it
# from the script before attempting to deploy.
SHOPIFY_API_KEY=""
SHOPIFY_API_PASSWORD=""
SHOPIFY_STORE_URL=""
SHOPIFY_THEME_ID=""

gem install shopify_theme
theme configure SHOPIFY_API_KEY SHOPIFY_API_PASSWORD SHOPIFY_STORE_URL SHOPIFY_THEME_ID
git diff-tree -r --no-commit-id --name-only --diff-filter=ACMRT $COMMIT_ID | xargs theme upload
git diff-tree -r --no-commit-id --name-only --diff-filter=D $COMMIT_ID | xargs theme remove
