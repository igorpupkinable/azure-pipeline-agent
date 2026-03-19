#!/bin/bash -e
################################################################################
##  File:  install-pipx-packages.sh
##  Desc:  Install tools via pipx
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/install.sh

export PATH="$PATH:/opt/pipx_bin"

pipx_packages=$(get_toolset_value ".pipx[] .package")

for package in $pipx_packages; do
    echo "Install $package into default python"
    pipx install $package
done

invoke_tests "Common" "PipxPackages"
