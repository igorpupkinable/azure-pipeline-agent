#!/bin/bash
if [[ ! -v DESTINATION_IMAGE_VERSION ]]; then
  echo "DESTINATION_IMAGE_VERSION is unset. Aborting..."
  exit 1
fi


set -a

# Build stage VM
PKR_VAR_build_number=${BUILD_NUMBER:-'00000000.0'}

# Destination image for Packer
[[ $DESTINATION_IMAGE_VERSION == 0.0.* ]] && GALLERY_STORAGE_CONFIG=(true LRS) || GALLERY_STORAGE_CONFIG=(false ZRS)
PKR_VAR_destination_image_shallow_replication=${GALLERY_STORAGE_CONFIG[0]}
PKR_VAR_destination_image_storage="Standard_${GALLERY_STORAGE_CONFIG[1]}"
PKR_VAR_destination_image_version=$DESTINATION_IMAGE_VERSION
PKR_VAR_os_disk_size_gb=${DESTINATION_OSDISK_SIZE:-30}

packer init -upgrade "$TEMPLATES_DIR/build.ubuntu-22_04.pkr.hcl"
packer build -only "${BUILD_NAME:-ubuntu-22_04}.azure-arm.image" $TEMPLATES_DIR
set +a
