#!/bin/bash
# Ensure a separate script is called in the event of an error
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/utilties/check_url.sh > ${HOME}/bin/check_url && chmod u+x ${HOME}/bin/check_url
#
# then use the script in your tests like
# check_url -t 6 -w 10 -o "--no-check-certificate --output-document=/dev/null" "url_to_check"
OPTIONS="--output-document=/dev/null"
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
  local tries=${1} && shift
  local cmd=${@}
  local status=0

  for (( i = 1; i <=${tries}; i++ )); do
    echo -e "Trying ($i of ${TRIES}) '${cmd}'"
    ${cmd} && break
    status=$?

    if [ $i -lt ${TRIES} ]; then
      echo -e "Waiting ${WAIT} seconds before trying again."
      echo "------------------------------------------------------------------------------------------------------"
      sleep "${WAIT}"
    fi
  done

  return ${status}
}

retry "${TRIES}" "wget ${OPTIONS} ${URL}"
