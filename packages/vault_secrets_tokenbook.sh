#!/bin/bash
# Create secrets for token book - Vault server
vault_token=$(cat ~/.vault-token)

# token book
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"token_book":"abcd-deezezr-5665765733-jddfjh-467674342455-fgdfjgfjg-45656776fef"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/token/book/jwttoken
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"token_book":"jfkfhdkjfhdf-3325565634DSFDSF-DSDfdsf67565-dddsdcz434322-fsjfkh556"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/token/book/pepperaccess
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"token_book":"f3f58d9022d157ec6a78d38a492d3d99e77f1828506670ce56be8cdadfe022a3"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/token/book/keyaccess
