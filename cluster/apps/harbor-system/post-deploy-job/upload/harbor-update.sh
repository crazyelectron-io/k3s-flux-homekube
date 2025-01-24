#!/bin/bash

REGISTRY_PUSH="${HARBOR_URL}"
NAMESPACE_PUSH="${HARBOR_NAMESPACE}"
ROBOT="robot$library+automation'

#determine the file to read
filename=${1:-./tools/harbor-images.txt}

stringContain() { case $2 in *$1* ) return 0;; *) return 1;; esac ;}

#check if the harbor token is specified
if [ -z ${HARBOR_TOKEN} ]
then
  echo "HARBOR_TOKEN environment variable for $ROBOT not set, exiting"
  exit 1
fi

#login to the harbor registry
echo $HARBOR_TOKEN | docker login registry.moerman.online -u $ROBOT --password-stdin >/dev/null

#loop through the lines in the inout file
IFS=$'\n'
for line in `cat $filename`; do
  echo ""
  echo "=============== Processing '$line' ==============="
  IFS=' '
  read -ra IN <<<"$line"     #reading str as an array of tokens separated by IFS
  #split namesapce off if present
  REGISTRY_PULL=${IN[0]}
  REPOSITORY_PULL=${IN[1]}
  TAG_PULL=${IN[2]:-latest}    #defaults to 'latest'
  REPOSITORY_PUSH=${IN[3]:-$REPOSITORY_PULL}
  TAG_PUSH=${IN[4]:-$TAG_PULL}
  IFS=$'\n'
  if [ $REGISTRY_PULL == \# ]
  then
    echo "---------- Skipping $REPOSITORY_PULL/$TAG_PULL:$REPOSITORY_PUSH"
  else
    PULL=$REGISTRY_PULL/$REPOSITORY_PULL:$TAG_PULL
    PUSH=$REGISTRY_PUSH/$NAMESPACE_PUSH/$REPOSITORY_PUSH:$TAG_PUSH
    echo "---------- Pulling $PULL"
    docker pull $PULL --platform linux/amd64
    result=$?
    echo $result
    if [ $result == 0 ]
    then
      echo "---------- Tagging $PULL as $PUSH"
      docker tag $PULL $PUSH
      echo "---------- Pushing $PUSH"
      docker push $PUSH
      echo "---------- Cleanup images"
      docker rmi $PUSH
      docker rmi $PULL
    else
      echo "********** Pull of image $PULL failed, exit code $result **********"
      exit 1
    fi
    echo "=============== Image for $IMG_PUSH processed ==============="
  fi
done
exit 0
