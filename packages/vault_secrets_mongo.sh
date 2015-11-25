#!/bin/bash
# Create secrets for Mongo - Vault server
vault_token=$(cat ~/.vault-token)

# create secrets oauth
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"database":"435f3f58d90d157ec6e8e022342156a3435f3f58d90d157ec6e8e022342156a3"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/mongo/database
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"jwttoken":"hjhgfjkghfkhfgkdf-434545656546211-jfdkgfdgkdf-4325464562ggtrger-34435546563"}' http://127.0.0.1:8200/v1/secret/bsensory/key/mongo/jwttoken
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"pepper":"ffdgre42354656vdfvef23434gfgrdfsdc45654Tddsdzdc34552442344545xqxdff345456567"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/mongo/pepper
