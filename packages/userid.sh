#!/bin/bash
# Generate user id for Vault authentication

hostname=`hostname`
echo $hostname

hash=`echo -n $hostname | echo -n 'FRSKL-4365768-SALT-7788989-ZRSIJNDE-1245'`
echo $hash

user_id=`echo -n $hostname | echo -n 'FRSKL-4365768-SALT-7788989-ZRSIJNDE-1245' | sha256sum | tr -d '-' | tr -d ' '`
echo $user_id
