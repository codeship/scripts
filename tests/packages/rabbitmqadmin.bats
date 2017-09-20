#!/usr/bin/env bats

# Requires RabbitMQ service to be running

setup() {
  mkdir -p "${HOME}/bin"
}

teardown() {
  rm $HOME/bin/rabbitmqadmin
}

@test "[rabbitmqadmin.sh] Installs successfully" {
  run ./packages/rabbitmqadmin.sh
  [ "$status" -eq 0 ]
}
