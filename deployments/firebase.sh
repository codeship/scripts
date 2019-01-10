#!/bin/bash
# 
# Add the following environment variables to your project configuration.
# * FIREBASE_TOKEN
# * PROJECTID
#
# To get firebase token, run `firebase login:ci` on your local machine
# https://github.com/firebase/firebase-tools#using-with-ci-systems
# To view your project id go to console.firebase.google.com

FIREBASE_TOKEN=${FIREBASE_TOKEN:?'You need to configure the FIREBASE_TOKEN environment variable!'}
PROJECTID=${PROJECTID:?'You need to configure the PROJECTID environment variable!'}

firebase deploy --token "$FIREBASE_TOKEN" --project "$PROJECTID"

# To deploy only to hosting
# firebase deploy --token "$FIREBASE_TOKEN" --project "$PROJECTID" --only hosting
# https://firebase.google.com/docs/cli/targets
