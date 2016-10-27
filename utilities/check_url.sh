#!/bin/bash
# Check a URL for a HTTP/2xx return code
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/utilities/check_url.sh > ${HOME}/bin/check_url && chmod u+x ${HOME}/bin/check_url
#
# then use the script in your tests like
# WGET_OPTIONS="--output-document=/dev/null" check_url -t 6 -w 10 "https://codeship.com"
OPTIONS=${WGET_OPTIONS:="--output-document=/dev/null"}
TRIES=6
WAIT=10

while getopts "t:w:" opt; do
  case $opt in
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

  if [ "${cmd/--no-check-certificate}" != "${cmd}" ]; then
    local original_cmd="${cmd}"
    cmd="${cmd/--no-check-certificate}"
  fi

  for (( i = 1; i <=${tries}; i++ )); do
    echo -e "Trying ($i of ${TRIES}) '${cmd}'"
    ${cmd}
    status=$?

    if [ ${status} -eq 0 ]; then
      break
    fi

    if [ ${status} -eq 5 -a "${original_cmd}" != "" ]; then
      echo -e "\e[0;33mCheck failed because of an error validating the SSL certificate.\e[0m"
      echo -e "\e[0;33mWe will retry without checking the certificate, but we'd encourage you to fix the\e[0m"
      echo -e "\e[0;33mcertificate settings for your application.\e[0m"
      cmd="${original_cmd}"
      status=0
    fi

    if [ $i -lt ${TRIES} ]; then
      echo -e "\e[0;36mWaiting ${WAIT} seconds before trying again.\e[0m"
      echo "------------------------------------------------------------------------------------------------------"
      sleep "${WAIT}"
    fi
  done

  return ${status}
}

retry "${TRIES}" "wget ${OPTIONS} ${URL}"
