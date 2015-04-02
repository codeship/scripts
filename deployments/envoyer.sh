#!/bin/sh
# Deploy via envoyer.io
#
# You can either add this here, or configure them on the environment tab of your
# project settings. See the _Deployment Hooks_ tab on Envoyer for the ID.
ENVOYER_ID=""

curl "https://envoyer.io/deploy/${ENVOYER_ID}"
