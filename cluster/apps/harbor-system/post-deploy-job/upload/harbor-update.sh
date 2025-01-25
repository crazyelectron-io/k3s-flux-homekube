#!/bin/bash
echo "=============== Processing ==============="
echo "Harbor Token:" $HARBOR_TOKEN
echo "Harbor URL:" $HARBOR_URL
echo "Harbor Namespace:" $HARBOR_NAMESPACE 
echo "Harbor robot account:" $HARBOR_ACCOUNT
echo "Harbor repositories file:" $HARBOR_REPOSITORIES

echo "Login to the harbor registry"
#echo $HARBOR_TOKEN | docker login $HARBOR_URL -u $HARBOR_ACCOUNT --password-stdin


# RESPONSE=$(curl "https://registry.moerman.online/api/v2.0/robots" \
#   -H 'athorization: Basic YWRtaW46ZGlybUVmLXphZ3ZpMC10ZXpkdXA=' \
#   -H 'content-type: application/json' \
#   -d '{
#        "count_limit": 10,
#        "project_name": "library",
#        "cve_whitelist": {
#          "items": [
#            {
#              "cve_id": "string"
#            }
#          ],
#          "project_id": 0,
#          "id": 0,
#          "expires_at": 0
#        },
#        "storage_limit": 10,
#        "metadata": {
#          "enable_content_trust": "true",
#          "auto_scan": "false",
#          "severity": "none",
#          "reuse_sys_cve_whitelist": "false",
#          "public": "true",
#          "prevent_vul": "false"
#        }
#      }' -k --verbose