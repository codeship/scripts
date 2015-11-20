#!/bin/bash
# Generate user id for Vault authentication

hostname=`hostname | tr -d ' '`
echo $hostname

hash="$hostnameFRSKL-4365768-SALT-7788989-ZRSIJNDE-1245"
echo $hash

user_id=`echo -n $hash | sha256sum | tr -d '-' | tr -d ' '`
echo $user_id
