#!/bin/bash -e
################################################################################
##  File:  install-azure-cli.sh
##  Desc:  Install Azure CLI (az)
################################################################################

# Install Azure CLI (instructions taken from https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
curl -fsSL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Source the helpers for use with the script
source $HELPER_SCRIPTS/etc-environment.sh

# AZURE_EXTENSION_DIR shell variable defines where modules are installed
# https://docs.microsoft.com/en-us/cli/azure/azure-cli-extensions-overview
export AZURE_EXTENSION_DIR=/opt/az/extensions
set_etc_environment_variable "AZURE_EXTENSION_DIR" "${AZURE_EXTENSION_DIR}"

# install azure devops Cli extension
az extension add --name azure-devops
