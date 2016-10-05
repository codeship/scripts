#!/bin/bash
# Check a whether a port is open or not
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/utilities/check_port.sh > ${HOME}/bin/check_port && chmod u+x ${HOME}/bin/check_port
#
# then use the script in your tests like
# check_port 9200

function check_port() {
  local host=${1} && shift
  local port=${1} && shift
  local retries=5
  local wait=1

  until( nc -zv ${host} ${port} ); do
    ((retries--))
    if [ $retries -lt 0 ]; then
      echo "Service ${host}:${port} didn't become ready in time."
      exit 1
    fi
    sleep "${wait}"
  done
}

check_port "localhost" "$@"
