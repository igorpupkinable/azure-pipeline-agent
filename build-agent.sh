#!/bin/bash
TEMPLATES_DIR=${TEMPLATES_DIR:-'images/ubuntu/templates'}

if [[ ! -v ARM_CLIENT_ID ]]; then
  echo "ARM_CLIENT_ID is unset. Aborting..."
  exit 1
fi

if [[ ! -v ARM_RESOURCE_GROUP ]]; then
  echo "ARM_RESOURCE_GROUP is unset. Aborting..."
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

if [[ ! -v BUILD_RG_NAME ]]; then
  echo "BUILD_RG_NAME is unset. Aborting..."
  exit 1
fi

if [[ ! -v RESULTING_IMAGE_NAME ]]; then
  echo "RESULTING_IMAGE_NAME is unset. Aborting..."
  exit 1
fi

set -a
# Packer authentication
PKR_VAR_client_cert_password=$ARM_CLIENT_CERT_PASSWORD
PKR_VAR_client_cert_path=$ARM_CLIENT_CERT_PATH
PKR_VAR_client_id=$ARM_CLIENT_ID
PKR_VAR_subscription_id=$ARM_SUBSCRIPTION_ID
PKR_VAR_tenant_id=$ARM_TENANT_ID

# Source image for Packer
PKR_VAR_source_image_sku=${AGENT_IMAGE_SKU:-0001-com-ubuntu-minimal-jammy:minimal-22_04-lts-gen2}
PKR_VAR_source_image_version=${AGENT_IMAGE_VERSION:-latest}

# Build stage VM
PKR_VAR_dockerhub_images=$DOCKERHUB_IMAGES
PKR_VAR_dockerhub_login=$DOCKERHUB_LOGIN
PKR_VAR_dockerhub_pat="$DOCKERHUB_PAT"

# Destination image for Packer
PKR_VAR_build_resource_group_name=$BUILD_RG_NAME
PKR_VAR_managed_image_name="Azure-Pipeline-Agent-$RESULTING_IMAGE_NAME"
PKR_VAR_managed_image_resource_group_name=$ARM_RESOURCE_GROUP
PKR_VAR_os_disk_size_gb=${AGENT_OSDISK_SIZE:-30}

packer init -upgrade "$TEMPLATES_DIR/build.ubuntu-22_04.pkr.hcl"
packer build -only "${BUILD_NAME:-ubuntu-22_04}.azure-arm.image" $TEMPLATES_DIR
set +a
