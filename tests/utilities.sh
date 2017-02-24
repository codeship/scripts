#!/bin/bash

set -e

# Test check_port
bash utilities/check_port.sh 3306
! bash utilities/check_port.sh 80

# Test check_url
bash utilities/check_url.sh -w 2 -t 2 https://codeship.com
! bash utilities/check_url.sh -w 2 -t 2 https://does_not_exist.codeship.com

# Test check_url certificate warnings
WGET_OPTIONS="--no-check-certificate" bash utilities/check_url.sh -w 2 -t 2 https://cacert.org
! bash utilities/check_url.sh -w 2 -t 2 https://cacert.org

# Test ensure_called
bash utilities/ensure_called.sh "echo Hello World" | grep "Hello World"
bash utilities/ensure_called.sh true false "echo Hello World" | grep "Hello World"
! bash utilities/ensure_called.sh false "echo Not Run" true | grep "Not Run"
! bash utilities/ensure_called.sh

# Test random_timezone
source utilities/random_timezone.sh
env | grep TZ
