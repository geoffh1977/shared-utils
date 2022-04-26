#!/bin/bash

# Connects To Docker Hub To Perform A Version Comparison

## Builds The URL For Docker Hub Tag Listings
function build_dockerhub_url {
  local dockerhub_user=$1
  local dockerhub_repo=$2
  if [ "${dockerhub_user}" == "_" ]
  then
    dockerhub_url="https://registry.hub.docker.com/api/content/v1/repositories/public/library/${dockerhub_repo}/tags/?page_size=1000"
  else
    dockerhub_url="https://hub.docker.com/v2/repositories/${dockerhub_user}/${dockerhub_repo}/tags/?page_size=1000"
  fi
  echo "${dockerhub_url}"
}

## Download The Latest Version Number From Docker Hub
function get_dockerhub_version {
  local dockerhub_user=$1
  local dockerhub_repo=$2
  local dockerhub_url=$(build_dockerhub_url "${dockerhub_user}" "${dockerhub_repo}")
  echo $(curl -s "${dockerhub_url}" | jq -r '.results[].name' | grep "\." | sort -rV | head -n1)
}

## Load Pipeline Variables For Local Run
[ -z ${BUILD_DOCKERHUB_TARGET_REPO} ] && eval $(./parse_yaml.sh pipeline_variables.yaml BUILD_)

## Download Version Data
SOURCE_VERSION=$(get_dockerhub_version "${BUILD_DOCKERHUB_SOURCE_USER}" "${BUILD_DOCKERHUB_SOURCE_REPO}")
CURRENT_VERSION=$(get_dockerhub_version "${BUILD_DOCKERHUB_TARGET_USER}" "${BUILD_DOCKERHUB_TARGET_REPO}")

## Perform Version Comparison
echo
if [ ! -z ${SOURCE_VERSION} ]
then
  if [ ! -z ${CURRENT_VERSION} ]
  then
    if [ ${SOURCE_VERSION} != ${CURRENT_VERSION} ]
    then
      echo "Current Image Is Out Of Date!"
      echo "Source Image Version: ${SOURCE_VERSION}"
      echo "Image Version: ${CURRENT_VERSION}"
      echo
      echo "A Rebuild Is Required!"
      export REBUILD="true"
      export TARGET_VERSION="${SOURCE_VERSION}"
    else
      echo "Current Image Is Up To Date!"
    fi
  else
    echo "ERROR: Current Version Of Software Not Found!"
    exit 1
  fi
else
  echo "ERROR: Source Version Of Software Not Found!"
  exit 1
fi
echo
