#!/bin/bash -e
################################################################################
##  File:  install-apt-packages.sh
##  Desc:  Install required packages using APT
################################################################################

# Install apt-utils as well
# See https://github.com/tianon/docker-brew-ubuntu-core/issues/59
apt-get update
apt-get --yes install \
  apt-utils curl apt-transport-https software-properties-common
