#!/bin/bash -e
################################################################################
##  File:  install-python.sh
##  Desc:  Install Python 3
################################################################################

set -e
# Source the helpers for use with the script
source $HELPER_SCRIPTS/etc-environment.sh
source $HELPER_SCRIPTS/os.sh

# Install Python, Python 3, pip, pip3
apt-get install --no-install-recommends python3 python3-dev python3-pip python3-venv

if is_ubuntu24; then
# Create temporary workaround to allow user to continue using pip
    sudo cat <<EOF > /etc/pip.conf
[global]
break-system-packages = true
EOF
fi

# Adding this dir to PATH will make installed pip commands are immediately available.
prepend_etc_environment_path '$HOME/.local/bin'

invoke_tests "Tools" "Python"
