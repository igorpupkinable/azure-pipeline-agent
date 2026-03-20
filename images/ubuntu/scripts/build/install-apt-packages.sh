#!/bin/bash -e
################################################################################
##  File:  install-apt-packages.sh
##  Desc:  Install required packages using APT
################################################################################

apt-get update
# apt-get install apt-transport-https ca-certificates curl software-properties-common
apt-get --yes install curl
apt-get --yes install apt-transport-https
apt-get --yes install software-properties-common

# Install vital packages if missing
apt-get --yes install wget

# apt-get dist-upgrade
