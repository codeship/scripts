#!/bin/sh
# Post to Slack channel on new deployment
# https://api.slack.com/incoming-webhooks
#
# You can either add those here, or configure them on the environment tab of your
# project settings.
SLACK_WEBHOOK_TOKEN=${SLACK_WEBHOOK_TOKEN:?'You need to configure the SLACK_WEBHOOK_TOKEN environment variable!'}
SLACK_BOT_NAME=${SLACK_BOT_NAME:="Codeship Bot"}
SLACK_ICON_URL=${SLACK_ICON_URL:="https://codeship.com/codeship-48x48.png"}
SLACK_MESSAGE=${SLACK_MESSAGE:?"${CI_COMMITTER_USERNAME} just deployed version ${CI_COMMIT_ID}"}

curl -X POST \
	-H "Content-Type: application/json" \
	-d '{"username": "'"${SLACK_BOT_NAME}"'",
	"text": "'"${SLACK_MESSAGE}"'",
	"icon_url": "'"${SLACK_ICON_URL}"'"}' \
	https://hooks.slack.com/services/$SLACK_WEBHOOK_TOKEN
