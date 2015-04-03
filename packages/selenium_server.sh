#!/bin/sh
# Install Selenium server, http://www.seleniumhq.org
#
# You can either add this here, or configure them on the environment tab of your
# project settings.
SELENIUM_VERSION="2.45.0"
SELENIUM_PORT="4444"
SELENIUM_OPTIONS=""

# exit on the first failure
set -e

MINOR_VERSION=${SELENIUM_VERSION%.*}
SELENIUM_JAR="${HOME}/cache/selenium-server-standalone-${SELENIUM_VERSION}.jar"

wget -O "${SELENIUM_JAR}" --continue "http://selenium-release.storage.googleapis.com/${MINOR_VERSION}/selenium-server-standalone-${SELENIUM_VERSION}.jar"

java -jar "${SELENIUM_JAR}" -port "${SELENIUM_PORT}" ${SELENIUM_OPTIONS} 2>&1 &
sleep 10
echo "Selenium is now ready to connect on port ${SELENIUM_PORT}..."
