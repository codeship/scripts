#!/bin/bash
# Initialize Vault authentication
#
name=`hostname`
salt="FRSKL-4365768-SALT-7788989-ZRSIJNDE-1245"

hash=$name$salt

# generate user id
#user_id=`echo -n $hash | sha256sum | tr -d '-' | tr -d ' '`
#echo $user_id

user_id="ca1beab9a9a421359282e5eb3c2a366836199e8f881c6210c570d13bfcf5e0a3"
echo $user_id

vault_token=$(cat ~/.vault-token)

# enable authentication backend
# curl -X POST -H "X-Vault-Token:$vault_token" -d '{"type":"app-id"}' http://127.0.0.1:8200/v1/sys/auth/app-id

# configure vault server app-id
curl -X POST -H "X-Vault-Token:$vault_token" -d '{"value":"root", "display_name":"demo_test"}' http://127.0.0.1:8200/v1/auth/app-id/map/app-id/89438492-AD4567-89082452256671456543244546-ADFB5565657-434654E33443546

# configure vault server user id
curl -X POST -H "X-Vault-Token:$vault_token" -d '{"value":"89438492-AD4567-89082452256671456543244546-ADFB5565657-434654E33443546"}' http://127.0.0.1:8200/v1/auth/app-id/map/user-id/$user_id
