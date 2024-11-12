#!/bin/bash

# Load environment variables from ../.env file
if [ -f ".env" ]; then
  source ".env"
else
  echo "Error: ../.env file not found."
  exit 1
fi

if [ $KEYCLOAK_SERVER_URL_EXT2 ]; then
  KEYCLOAK_URL=$KEYCLOAK_SERVER_URL_EXT
else
  KEYCLOAK_URL="http://localhost:8104/"
fi
#KEYCLOAK_URL=${KEYCLOAK_SERVER_URL_EXT:"http://-localhost:8080}

echo
echo "KEYCLOAK_URL: $KEYCLOAK_URL"

echo
echo "Getting admin access token"
echo "=========================="

ADMIN_TOKEN=$(curl -s -X POST \
"$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "username=admin" \
-d 'password=admin' \
-d 'grant_type=password' \
-d 'client_id=admin-cli' | jq -r '.access_token')

echo "ADMIN_TOKEN=$ADMIN_TOKEN"

echo
echo "Creating client"
echo "==============="

CLIENT_ID=$(curl -si -X POST "${KEYCLOAK_URL}/admin/realms/master/clients" \
-H "Authorization: Bearer $ADMIN_TOKEN" \
-H "Content-Type: application/json" \
-d '
{
  "clientId": "app",
  "directAccessGrantsEnabled": true,
  "redirectUris": ["http://localhost:80"]
}' \
| grep -oE '[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}')

echo "CLIENT_NAME=app"
echo "CLIENT_ID=$CLIENT_ID"

echo
echo "Getting client secret"
echo "====================="

SIMPLE_SERVICE_CLIENT_SECRET=$(curl -s "$KEYCLOAK_URL/admin/realms/master/clients/$CLIENT_ID/client-secret" \
-H "Authorization: Bearer $ADMIN_TOKEN" \
| jq -r '.value')

echo "SIMPLE_SERVICE_CLIENT_SECRET(KEYCLOAK_CLIENT_SECRET_KEY)=$SIMPLE_SERVICE_CLIENT_SECRET"

echo
echo "Creating new user"
echo "====================="

curl -i -X POST "$KEYCLOAK_URL/admin/realms/master/users" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $ADMIN_TOKEN" \
-d '{
  "firstName": "Toto",
  "lastName": "Titi",
  "enabled": true,
  "username": "toto",
  "credentials": [{
    "type": "password",
    "value": "password",
    "temporary": false
  }]
}'

echo "Username: toto"
echo "Password: password"
