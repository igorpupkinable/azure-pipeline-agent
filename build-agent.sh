#!/bin/bash
if [[ ! -v DESTINATION_IMAGE_VERSION ]]; then
  echo "DESTINATION_IMAGE_VERSION is unset. Aborting..."
  exit 1
fi

if [[ ! -v IMAGE_NAME ]]; then
  echo "IMAGE_NAME is unset. Aborting..."
  exit 1
fi

set -a
# Source and destination
PKR_VAR_gallery_image_name=$IMAGE_NAME

# Source image for Packer
PKR_VAR_source_image_version=${SOURCE_IMAGE_VERSION:-latest}

# Build stage VM
PKR_VAR_build_number=${BUILD_NUMBER:-'00000000.0'}
PKR_VAR_dockerhub_images="$DOCKERHUB_IMAGES"
PKR_VAR_dockerhub_login=$DOCKERHUB_LOGIN
PKR_VAR_dockerhub_pat="$DOCKERHUB_PAT"

# Destination image for Packer
[[ $DESTINATION_IMAGE_VERSION == 0.0.* ]] && GALLERY_STORAGE_CONFIG=(true LRS) || GALLERY_STORAGE_CONFIG=(false ZRS)
PKR_VAR_destination_image_shallow_replication=${GALLERY_STORAGE_CONFIG[0]}
PKR_VAR_destination_image_storage="Standard_${GALLERY_STORAGE_CONFIG[1]}"
PKR_VAR_destination_image_version=$DESTINATION_IMAGE_VERSION
PKR_VAR_os_disk_size_gb=${DESTINATION_OSDISK_SIZE:-30}

packer init -upgrade "$TEMPLATES_DIR/build.ubuntu-22_04.pkr.hcl"
packer build -only "${BUILD_NAME:-ubuntu-22_04}.azure-arm.image" $TEMPLATES_DIR
set +a
