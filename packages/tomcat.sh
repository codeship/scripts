TOMCAT_VERSION=${TOMCAT_VERSION:="8.5.9"}
TOMCAT_DIR=${TOMCAT_DIR="$HOME/tocat"}
TOMCAT_WAIT_TIME=${TOMCAT_WAIT_TIME:="10"}


set -e
CACHED_DOWNLOAD="${HOME}/cache/apache-tomcat-${TOMCAT_VERSION}.tar.gz"

mkdir -p "${TOMCAT_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "http://www-us.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --directory "${TOMCAT_DIR}"

bash ${TOMCAT_DIR}/bash apache-tomcat-${TOMCAT_VERSION}/bin/startup.sh
sleep ${TOMCAT_SLEEP_TIME}
cd -
