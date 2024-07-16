#!/bin/bash

# Declaring variables
SIGNING_ROLE="vault-role"
REMOTE_USER="remote-server-user"
REMOTE_HOST="remote-host"
LDAP_USERNAME="username"

if [[ -n ${1} ]]; then
    LDAP_PASSWORD=$1
else
    echo "LDAP Password parameter missing"
    exit 1
fi

# SIGNED CRT TTL
CRT_EXPIRY_TIME="2m"

# GET TOKEN USING API 
TOKEN=$(curl -ks --request POST \
  --data "{\"password\": \"$LDAP_PASSWORD\"}" \
  https://<vault-url>/v1/auth/ldap/login/$LDAP_USERNAME | \
  jq -r '.auth.client_token')

# echo "Vault token: $TOKEN"

# SIGN PRIV KEY USING ROLE
RESPONSE=$(curl --location -ks "https://<vault-url>/v1/ssh-client-signer/issue/$SIGNING_ROLE" \
--header 'Content-Type: application/json' \
--header "Authorization: Bearer $TOKEN" \
--data "{
  \"key_type\": \"ed25519\",
  \"valid_principals\": \"$REMOTE_USER\",
  \"ttl\": \"$CRT_EXPIRY_TIME\"
}" | jq -r .data)

# RETRIEVE PRIV & SIGNED CRT     
echo $RESPONSE | jq -r .private_key > private_key.key
echo $RESPONSE | jq -r .signed_key > signed_key.key

chmod 400 *.key

# LOGIN 
ssh -i signed_key.key -i private_key.key $REMOTE_USER@$REMOTE_HOST