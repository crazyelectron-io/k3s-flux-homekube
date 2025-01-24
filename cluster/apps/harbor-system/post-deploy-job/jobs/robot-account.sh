#!/bin/bash
echo ".......... Installing Required Packages ............"
apt-get update
apt-get install --no-install-recommends --no-install-suggests curl jq ca-certificates -y
echo ".......... Creating Harbor Robot Account ............"
# Create robot account
ROBOT_RESPONSE=$(curl -v -u "${SECRET_HARBOR_ADMIN_USER}:${SECRET_HARBOR_ADMIN_PASSWORD}" "https://registry.${SECRET_DOMAIN_0}/api/v2.0/robots" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "automation",
    "description": "Robot account for Automation",
    "level": "project",
    "permissions": [
      {
        "kind": "project",
        "namespace": "library",
        "access": [
          {
            "action": "pull",
            "resource": "repository"
          },
          {
            "action": "push",
            "resource": "repository"
          },
          {
            "action": "create",
            "resource": "tag"
          },
          {
            "action": "delete",
            "resource": "tag"
          },
          {
            "action": "create",
            "resource": "artifact-label"
          },
          {
            "action": "list",
            "resource": "artifact"
          },
          {
            "action": "list",
            "resource": "repository"
          }
        ]
      }
    ]
  }')

# For debugging purposes
echo ".. $ROBOT_RESPONSE .."
# Extract robot account name and secret
ROBOT_ACCOUNT=$(echo $ROBOT_RESPONSE | jq -r '.name')
ROBOT_ID=$(echo $ROBOT_RESPONSE | jq -r '.id')
ROBOT_SECRET=$(echo $ROBOT_RESPONSE | jq -r '.secret')

echo ".......... Harbor Robot Account Created ............"
# Output robot account details for debugging purposes
echo "Robot Account: $ROBOT_ACCOUNT"
echo "Robot ID: $ROBOT_ID"
echo "Robot Secret: $ROBOT_SECRET"

echo ".......... Setting Harbor Robot account Secret ............"
# Patch robot account secret
ROBOT_RESPONSE=$(curl -v -X PATCH -u "${SECRET_HARBOR_ADMIN_USER}:${SECRET_HARBOR_ADMIN_PASSWORD}" "https://registry.${SECRET_DOMAIN_0}/api/v2.0/robots/$ROBOT_ID" \
  -H "Content-Type: application/json" \
  -d '{
    "secret": "${SECRET_HARBOR_ROBOT_SECRET}"
  }')
