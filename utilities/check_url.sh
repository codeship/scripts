#!/bin/bash
# Ensure a separate script is called in the event of an error
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/utilties/check_url.sh > ${HOME}/bin/check_url && chmod u+x ${HOME}/bin/check_url
#
# then use the script in your tests like
# check_url -t 6 -w 10 -o "--no-check-certificate --output-document=/dev/null" "url_to_check"
OPTIONS="--no-check-certificate --output-document=/dev/null"
TRIES=6
WAIT=10

while getopts "t:w:o" opt; do
  case $opt in
    o)
      OPTIONS=${OPTARG}
      ;;
    t)
      TRIES=${OPTARG}
      ;;
    w)
      WAIT=${OPTARG}
      ;;
  esac
done

# set the URL
URL=${@}

function retry {
  local count=${1} && shift
  local cmd=${@}

  while [ $count -gt 0 ]; do
    echo -e "Trying ($((${TRIES} - ${count} + 1)) of ${TRIES}) '${cmd}'"
    ${cmd} && break
    count=$(($count - 1))
    if [ ! $count -eq 0 ]; then
      echo -e "Waiting ${WAIT} seconds before trying again."
      echo "------------------------------------------------------------------------------------------------------"
      sleep "${WAIT}"
    fi
  done

  if [ $count -eq 0 ]; then
    return 1
  else
    return 0
  fi
}

retry "${TRIES}" "wget ${OPTIONS} ${URL}"
