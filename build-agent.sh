#!/bin/bash
TEMPLATES_DIR=${TEMPLATES_DIR:-'images/ubuntu/templates'}

if [[ ! -v ARM_CLIENT_ID ]]; then
  echo "ARM_CLIENT_ID is unset. Aborting..."
  exit 1
fi

if [[ ! -v ARM_OBJECT_ID ]]; then
  echo "ARM_OBJECT_ID is unset. Aborting..."
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

packer init -upgrade "$TEMPLATES_DIR/build.ubuntu-22_04.pkr.hcl"
packer build -only "${BUILD_NAME:-ubuntu-22_04}.azure-arm.image" -var "image_os=${IMAGE_OS:-ubuntu22}" -var "managed_image_name=Azure-Pipeline-Agent-$RESULTING_IMAGE_NAME" -var "os_disk_size_gb=${OSDISK_SIZE:-30}" -var "vm_size=${VM_SIZE:-Standard_D4s_v4}" $TEMPLATES_DIR
