#!/bin/bash
# Create secrets for OAuth - Vault server
vault_token=$(cat ~/.vault-token)

# create secrets oauth
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"oauth":"hfjrtgrhjgrhj-658953894234-hrhiuerbxbs-323494775fggff-37293729321ssdndv"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/oauth/jwttoken
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"oauth":"yzeflodzezd-44849348Dde-ezueszifroerzsswx-43676743E2-hfjkdfhdjkfsf34564"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/oauth/pepperaccess
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"oauth":"f3f58d9022d157ec6a78d38a492d3d99e77f1828506670ce56be8cdadfe022a2"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/oauth/keyaccess
curl -X POST -H "X-Vault-Token:$vault_token" -H 'Content-type: application/json' -d '{"oauth":"jkjsdhfjkbd-12244556CSDSQ-QDFJDFGDJDZEFDSFCSZA-53454235FScCdqsdza-434Dz"}' http://127.0.0.1:8200/v1/secret/bsensory/keys/oauth/pepperrefresh
