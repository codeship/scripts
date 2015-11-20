#!/bin/bash
# Generate user id for Vault authentication

name=`hostname`
salt="FRSKL-4365768-SALT-7788989-ZRSIJNDE-1245"

hash=$name$salt

user_id=`echo -n $hash | sha256sum | tr -d '-' | tr -d ' '`
echo $user_id

vault_token=$(cat ~/.vault-token)
curl -X POST -H "X-Vault-Token:$vault_token" -d '{"value":"89438492-AD4567-89082452256671456543244546-ADFB5565657-434654E33443546"}' http://127.0.0.1:8200/v1/auth/app-id/map/user-id/$user_id
