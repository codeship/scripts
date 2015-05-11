#!/bin/bash
# Install SBT, a build tool for Scale - http://www.scala-sbt.org/
# manual installation taken from http://www.scala-sbt.org/0.13/tutorial/Manual-Installation.html
#
# Include in your builds via
# https://raw.githubusercontent.com/codeship/scripts/master/packages/sbt.sh | bash -s
SBT_VERSION=${SBT_VERSION:="0.13.8"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/sbt-${SBT_VERSION}.jar"

wget --continue --output-document "${CACHED_DOWNLOAD}" "https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar"
echo 'SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"' > "${HOME}/bin/sbt"
echo "java $SBT_OPTS -jar ${CACHED_DOWNLOAD} \"$@\"" >> "${HOME}/bin/sbt"
chmod u+x "${HOME}/bin/sbt"
