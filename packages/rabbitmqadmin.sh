#!/bin/bash
# Installs rabbitmqadmin tool -- http://www.rabbitmq.com/management-cli.html
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/rabbitmqadmin.sh)"

curl "http://localhost:15672/cli/rabbitmqadmin" > "${HOME}/bin/rabbitmqadmin"
chmod u+x "${HOME}/bin/rabbitmqadmin"
rabbitmqadmin --version
