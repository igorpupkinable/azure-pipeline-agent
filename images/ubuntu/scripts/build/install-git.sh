#!/bin/bash -e
################################################################################
##  File:  install-git.sh
##  Desc:  Install Git
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/install.sh

add-apt-repository "ppa:git-core/ppa" -y
curl -fsSL https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash

apt-get update
apt-get install git git-lfs

# Git version 2.35.2 introduces security fix that breaks action\checkout https://github.com/actions/checkout/issues/760
cat <<EOF >> /etc/gitconfig
[safe]
        directory = *
EOF

# Add well-known SSH host keys to known_hosts
ssh-keyscan -t rsa,ecdsa,ed25519 github.com >> /etc/ssh/ssh_known_hosts
ssh-keyscan -t rsa ssh.dev.azure.com >> /etc/ssh/ssh_known_hosts
