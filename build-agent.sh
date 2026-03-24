#!/bin/bash
TEMPLATES_DIR=${TEMPLATES_DIR:-'images/ubuntu/templates'}

if [[ ! -v ARM_CLIENT_ID ]]; then
  echo "ARM_CLIENT_ID is unset. Aborting..."
  exit 1
fi

if [[ ! -v ARM_SUBSCRIPTION_ID ]]; then
  echo "ARM_SUBSCRIPTION_ID is unset. Aborting..."
  exit 1
fi

if [[ ! -v ARM_TENANT_ID ]]; then
  echo "ARM_TENANT_ID is unset. Aborting..."
  exit 1
fi

if [[ ! -v ARM_CLIENT_CERT_PASSWORD ]]; then
  echo "ARM_CLIENT_CERT_PASSWORD is unset. Aborting..."
  exit 1
fi

if [[ ! -v ARM_CLIENT_CERT_PATH ]]; then
  echo "ARM_CLIENT_CERT_PATH is unset. Aborting..."
  exit 1
fi

if [[ ! -v BUILD_GALLERY_NAME ]]; then
  echo "BUILD_GALLERY_NAME is unset. Aborting..."
  exit 1
fi

if [[ ! -v BUILD_RESOURCE_GROUP ]]; then
  echo "BUILD_RESOURCE_GROUP is unset. Aborting..."
  exit 1
fi

if [[ ! -v BUILD_RG_NAME ]]; then
  echo "BUILD_RG_NAME is unset. Aborting..."
  exit 1
fi

if [[ ! -v DESTINATION_IMAGE_VERSION ]]; then
  echo "DESTINATION_IMAGE_VERSION is unset. Aborting..."
  exit 1
fi

if [[ ! -v IMAGE_NAME ]]; then
  echo "IMAGE_NAME is unset. Aborting..."
  exit 1
fi

set -a
# Packer authentication
PKR_VAR_client_cert_password=$ARM_CLIENT_CERT_PASSWORD
PKR_VAR_client_cert_path=$ARM_CLIENT_CERT_PATH
PKR_VAR_client_id=$ARM_CLIENT_ID
PKR_VAR_subscription_id=$ARM_SUBSCRIPTION_ID
PKR_VAR_tenant_id=$ARM_TENANT_ID

# Source and destination
PKR_VAR_gallery_name=$BUILD_GALLERY_NAME
PKR_VAR_gallery_image_name=$IMAGE_NAME
PKR_VAR_resource_group_name=$BUILD_RESOURCE_GROUP

# Source image for Packer
PKR_VAR_source_image_version=${SOURCE_IMAGE_VERSION:-latest}

# Build stage VM
PKR_VAR_dockerhub_images=$DOCKERHUB_IMAGES
PKR_VAR_dockerhub_login=$DOCKERHUB_LOGIN
PKR_VAR_dockerhub_pat="$DOCKERHUB_PAT"

# Destination image for Packer
[[ $DESTINATION_IMAGE_VERSION == 0.0.* ]] && GALLERY_STORAGE_CONFIG=(true LRS) || GALLERY_STORAGE_CONFIG=(false ZRS)
PKR_VAR_build_resource_group_name=$BUILD_RG_NAME
PKR_VAR_destination_image_shallow_replication=${GALLERY_STORAGE_CONFIG[0]}
PKR_VAR_destination_image_storage="Standard_${GALLERY_STORAGE_CONFIG[1]}"
PKR_VAR_destination_image_version=$DESTINATION_IMAGE_VERSION
PKR_VAR_os_disk_size_gb=${DESTINATION_OSDISK_SIZE:-30}

packer init -upgrade "$TEMPLATES_DIR/build.ubuntu-22_04.pkr.hcl"
packer build -only "${BUILD_NAME:-ubuntu-22_04}.azure-arm.image" $TEMPLATES_DIR
set +a
