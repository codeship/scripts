configure_java() {
  source "${HOME}/bin/jdk/jdk_switcher"
  jdk_switcher home openjdk8
  jdk_switcher use openjdk8
}

cleanup() {
  kill -SIGTERM $(jps | grep Elasticsearch | grep -o "[0-9]\+")
  rm -rf "${HOME}/el"
  rm -f "${HOME}/cache/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz"
  unset ELASTICSEARCH_VERSION
  unset ELASTICSEARCH_PORT
}
