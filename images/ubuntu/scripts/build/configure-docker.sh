#!/bin/bash -e
################################################################################
##  File:  configure-docker.sh
##  Desc:  Configure Docker
################################################################################

if [[ -z $DOCKERHUB_LOGIN || -z $DOCKERHUB_PAT ]]; then
  echo No Docker Hub credentials provided
else
  DOCKERHUB_CREDENTIALS_PROVIDED=true
fi

# Remove surrounding quotes
DOCKERHUB_IMAGES="${DOCKERHUB_IMAGES%\'}"
DOCKERHUB_IMAGES="${DOCKERHUB_IMAGES#\'}"

# Cache images of provided tags
DOCKERHUB_IMAGES=($DOCKERHUB_IMAGES)
LENGTH=${#DOCKERHUB_IMAGES[@]}

if (( $LENGTH > 0 )); then
  if [[ -v DOCKERHUB_CREDENTIALS_PROVIDED ]]; then
    echo $DOCKERHUB_PAT | docker login --username $DOCKERHUB_LOGIN --password-stdin
    echo $DOCKERHUB_PAT | docker login --username $DOCKERHUB_LOGIN --password-stdin dhi.io
  fi

  echo "$LENGTH image tags provided"

  for image in ${DOCKERHUB_IMAGES[@]}; do
    docker pull $image
  done

  if [[ -v DOCKERHUB_CREDENTIALS_PROVIDED ]]; then
    docker logout
    docker logout dhi.io
  fi
else
  echo No image tags provided. Skip caching
fi

docker image list --format table
df --human-readable --type=ext4
