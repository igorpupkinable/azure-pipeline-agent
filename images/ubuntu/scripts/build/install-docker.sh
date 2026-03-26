#!/bin/bash -e
################################################################################
##  File:  install-docker.sh
##  Desc:  Install docker onto the image
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/install.sh
source $HELPER_SCRIPTS/os.sh

REPO_URL="https://download.docker.com/linux/ubuntu"
GPG_KEY="/usr/share/keyrings/docker.gpg"
REPO_PATH="/etc/apt/sources.list.d/docker.list"
os_codename=$(lsb_release -cs)

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o $GPG_KEY
echo "deb [arch=amd64 signed-by=$GPG_KEY] $REPO_URL ${os_codename} stable" > $REPO_PATH
apt-get update
apt-get --yes install \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# docker from official repo introduced different GID generation: https://github.com/actions/runner-images/issues/8157
gid=$(cut -d ":" -f 3 /etc/group | grep "^1..$" | sort -n | tail -n 1 | awk '{ print $1+1 }')
groupmod -g "$gid" docker

# This configuration changes will not be reported in Docker info below
# However it does take effect later
cat <<EOF > /etc/docker/daemon.json
{
  "log-driver": "journald"
}
EOF

# Create systemd-tmpfiles configuration for Docker
cat <<EOF | sudo tee /etc/tmpfiles.d/docker.conf
L /run/docker.sock - - - - root docker 0770
EOF

# Reload systemd-tmpfiles to apply the new configuration
systemd-tmpfiles --create /etc/tmpfiles.d/docker.conf

# Enable docker.service
systemctl is-active --quiet docker.service || systemctl start docker.service
systemctl is-enabled --quiet docker.service || systemctl enable docker.service

# Docker daemon takes time to come up after installing
sleep 10
docker info
