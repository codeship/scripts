#!/usr/bin/env bats
DESCRIPTION_VERSION="2.4.6"
load elasticsearch_functions

setup() {
  export ELASTICSEARCH_VERSION="2.4.6"
  export ELASTICSEARCH_PORT="9333"
}

@test "[elasticsearch.sh $DESCRIPTION_VERSION] Script runs" {
  configure_java
  ./packages/elasticsearch.sh
}

@test "[elasticsearch.sh $DESCRIPTION_VERSION] Download cached" {
  [ -f "${HOME}/cache/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz" ]
}

@test "[elasticsearch.sh $DESCRIPTION_VERSION] Verify version and service is running" {
  run curl http://localhost:${ELASTICSEARCH_PORT}
  [[ "$output" =~ "\"number\" : \"${ELASTICSEARCH_VERSION}\"" ]]
  cleanup
}
