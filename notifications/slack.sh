#!/bin/sh
# Post to Slack channel on new deployment
# https://api.slack.com/incoming-webhooks
#
# You can either add those here, or configure them on the environment tab of your
# project settings.
SLACK_WEBHOOK_TOKEN=${SLACK_WEBHOOK_TOKEN:?'You need to configure the SLACK_WEBHOOK_TOKEN environment variable!'}
SLACK_BOT_NAME=${SLACK_BOT_NAME:="Codeship Bot"}
SLACK_ICON_URL=${SLACK_ICON_URL:="https://d1089v03p3mzyq.cloudfront.net/assets/website/logo-dark-90f893a2645c98929b358b2f93fa614b.png"}

curl -X POST \
	-H "Content-Type: application/json" \
	-d '{"username": "'"${SLACK_BOT_NAME}"'",
	"text": "'"${CI_COMMITTER_USERNAME} just deployed version ${CI_COMMIT_ID}"'",
	"icon_url": "'"${SLACK_ICON_URL}"'"}' \
	https://hooks.slack.com/services/$SLACK_WEBHOOK_TOKEN

curl -X POST \
	-H "Content-Type: application/json" \
	-d '{"username": "'"${SLACK_BOT_NAME}"'",
	"text": "'"Running a new build on Codeship"'",
	"icon_url": "'"${SLACK_ICON_URL}"'"}' \
	https://hooks.slack.com/services/$SLACK_WEBHOOK_TOKEN
