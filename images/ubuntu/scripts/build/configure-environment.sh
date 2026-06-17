#!/bin/bash -e
################################################################################
##  File:  configure-environment.sh
##  Desc:  Configure system and environment
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/os.sh
source $HELPER_SCRIPTS/etc-environment.sh

# Set the ACCEPT_EULA variable to Y value to confirm your acceptance of the End-User Licensing Agreement
set_etc_environment_variable "ACCEPT_EULA" "Y"

# This directory is supposed to be created in $HOME and owned by user(https://github.com/actions/runner-images/issues/491)
mkdir -p /etc/skel/.config/configstore
set_etc_environment_variable "XDG_CONFIG_HOME" '$HOME/.config'

# Add localhost alias to ::1 IPv6
sed -i 's/::1 ip6-localhost ip6-loopback/::1     localhost ip6-localhost ip6-loopback/g' /etc/hosts

# https://github.com/actions/runner-images/pull/7860
netfilter_rule='/etc/udev/rules.d/50-netfilter.rules'
echo 'ACTION=="add", SUBSYSTEM=="module", KERNEL=="nf_conntrack", RUN+="/usr/sbin/sysctl net.netfilter.nf_conntrack_tcp_be_liberal=1"' | tee -a $netfilter_rule

# https://github.com/actions/runner-images/issues/13770
# https://github.com/ravendb/ravendb/discussions/22410
# Linux kernel 6.17 changed read_ahead_kb default from 128 to 4096 on Azure VMs
# where disks are presented as rotational (ROTA=1). This floods the page cache
# with unused data during random-access I/O and causes memory exhaustion and thrashing.
if ! is_ubuntu22; then
    readahead_rule='/etc/udev/rules.d/99-readahead.rules'
    echo 'ACTION=="add|change", KERNEL=="sd*", ATTR{queue/read_ahead_kb}="128"' | tee "$readahead_rule"
fi

# Disable motd updates metadata
sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news

# Disable to load providers
# https://github.com/microsoft/azure-pipelines-agent/issues/3834
if is_ubuntu22; then
    sed -i 's/openssl_conf = openssl_init/#openssl_conf = openssl_init/g' /etc/ssl/openssl.cnf
fi