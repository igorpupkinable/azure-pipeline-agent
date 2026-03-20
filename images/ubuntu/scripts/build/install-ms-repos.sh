#!/bin/bash -e
################################################################################
##  File:  install-ms-repos.sh
##  Desc:  Install official Microsoft package repos for the distribution
################################################################################

wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

apt-get update
echo Sources Updated
# apt-get install apt-transport-https ca-certificates curl software-properties-common
apt-get install ca-certificates
apt-get install curl
apt-get install apt-transport-https
apt-get install software-properties-common

# Install vital packages if missing
apt-get install wget

# apt-get dist-upgrade
