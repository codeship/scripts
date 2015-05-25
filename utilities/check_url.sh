#!/bin/bash
# Ensure a separate script is called in the event of an error
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/utilties/check_url.sh > ${HOME}/bin/check_url && chmod u+x ${HOME}/bin/check_url
#
# then use the script in your tests like
# check_url "url_to_check"
URL=${@}
WGET_OPTIONS="--no-check-certificate --output-document=/dev/null"
TRIES=6
SLEEP=10

while getopts "t:w:o" opt; do
  case $opt in
    t)
      TRIES=${OPTARG}
      ;;
    w)
      SLEEP=${OPTARG}
      ;;
    o)
      WGET_OPTIONS=${OPTARG}
      ;;
  esac
done

function retry {
  local count=${1} && shift
  local cmd=${@}

  while [ $count -gt 0 ]; do
    echo -e "Trying ($((${TRIES} - ${count} + 1)) of ${TRIES}) '${cmd}'"
    ${cmd} && break
    count=$(($count - 1))
    if [ ! $count -eq 0 ]; then
      echo -e "Waiting ${SLEEP} seconds before trying again."
      echo "------------------------------------------------------------------------------------------------------"
      sleep "${SLEEP}"
    fi
  done

  if [ $count -eq 0 ]; then
    return 1
  else
    return 0
  fi
}

retry "${TRIES}" "wget ${WGET_OPTIONS} ${URL}"
