#!/bin/sh
# Post to Slack channel on new deployment
# https://api.slack.com/incoming-webhooks
#
# You can either add those here, or configure them on the environment tab of your
# project settings.
SLACK_WEBHOOK_TOKEN="T02CLSA7U/B051FFP0B/jtRHTrx7rp2un5rS3gsmZvKQ"
SLACK_BOT_NAME="Codeship Bot"
SLACK_ICON_URL="https://d1089v03p3mzyq.cloudfront.net/assets/website/logo-dark-90f893a2645c98929b358b2f93fa614b.png"

curl -X POST \
	-H "Content-Type: application/json" \
	-d '{"username": "'"${SLACK_BOT_NAME}"'",
	"text": "'"Deployed #${CI_COMMIT_ID} : ${CI_MESSAGE} by ${CI_COMMITTER_USERNAME}"'",
	"icon_url": "'"${SLACK_ICON_URL}"'"}' \
	https://hooks.slack.com/services/$SLACK_WEBHOOK_TOKEN
