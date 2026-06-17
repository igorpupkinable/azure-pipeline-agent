#!/bin/bash
set -a
# Destination image for Packer
[[ $PKR_VAR_destination_image_version == 0.0.* ]] && GALLERY_STORAGE_CONFIG=(true LRS) || GALLERY_STORAGE_CONFIG=(false ZRS)
PKR_VAR_destination_image_shallow_replication=${GALLERY_STORAGE_CONFIG[0]}
PKR_VAR_destination_image_storage="Standard_${GALLERY_STORAGE_CONFIG[1]}"

packer init -upgrade "$TEMPLATES_DIR/build.ubuntu-22_04.pkr.hcl"
packer build -only "${BUILD_NAME:-ubuntu-22_04}.azure-arm.image" $TEMPLATES_DIR
set +a
