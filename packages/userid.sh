#!/bin/bash
# Generate user id for Vault authentication

name=`hostname`
salt="FRSKL-4365768-SALT-7788989-ZRSIJNDE-1245"
echo $name
echo $salt

hash=$name$salt
echo $hash

user_id=`echo -n $hash | sha256sum | tr -d '-' | tr -d ' '`
echo $user_id
