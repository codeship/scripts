#!/bin/bash
# Create secrets for Mongo - Vault server
vault_token=$(cat ~/.vault-token)

# create secrets oauth
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"database":"435f3f58d90d157ec6e8e022342156a3435f3f58d90d157ec6e8e022342156a3"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/secure/database
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"pepper":"ffdgre42354656vdfvef23434gfgrdfsdc45654Tddsdzdcxqxdff345456567"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/secure/pepper
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"salt":"ffdgre42354656vdfvefkhk545342hh454434214689997hjh43242344dde22"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/secure/salt

