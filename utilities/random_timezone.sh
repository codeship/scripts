#!/bin/sh
# Set a random timezone
TZ_SIGN=$( echo "+:-" | cut -d: -f "$( shuf -i 1-2 -n 1 )" )
TZ=UTC${TZ_SIGN}$( shuf -i 0-24 -n1 )
export TZ
echo "Set TZ to: ${TZ}"
