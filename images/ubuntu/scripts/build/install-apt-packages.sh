#!/bin/bash -e
################################################################################
##  File:  install-apt-packages.sh
##  Desc:  Install required packages using APT
################################################################################

apt-get update
apt-get --yes --no-install-recommends --no-install-suggests install \
  apt-utils curl apt-transport-https software-properties-common
