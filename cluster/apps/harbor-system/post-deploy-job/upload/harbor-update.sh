#!/bin/bash
echo "=============== Processing ==============="
echo "Harbor Token:" $HARBOR_TOKEN
echo "Harbor URL:" $HARBOR_URL
echo "Harbor Namespace:" $HARBOR_NAMESPACE 
echo "Harbor robot account:" $HARBOR_ACCOUNT
echo "Harbor repositories file:" $HARBOR_REPOSITORIES

dig $HARBOR_URL

echo "Login to the harbor registry"
echo $HARBOR_TOKEN | docker login $HARBOR_URL -u $HARBOR_ACCOUNT --password-stdin
