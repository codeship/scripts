#!/bin/sh
# Install SBT, a build tool for Scale - http://www.scala-sbt.org/
# manual installation taken from http://www.scala-sbt.org/0.13/tutorial/Manual-Installation.html
#
# You can either add this here, or configure the version on the environment tab
# of your project settings.
SBT_VERSION="0.13.8"

set -e
mkdir -p "${HOME}/cache/sbt"
wget --continue -O "${HOME}/cache/sbt/sbt-${SBT_VERSION}.jar" "https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar"

echo 'SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"' > "${HOME}/bin/sbt"
echo "java $SBT_OPTS -jar ${HOME}/cache/sbt/sbt-${SBT_VERSION}.jar \"$@\"" >> "${HOME}/bin/sbt"
chmod u+x "${HOME}/bin/sbt"
