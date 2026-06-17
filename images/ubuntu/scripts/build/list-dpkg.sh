#!/bin/bash -e
################################################################################
##  File:  list-dpkg.sh
##  Desc:  List all installed dpkg packages
################################################################################
FILENAME=/tmp/installed-packages.txt

echo "Dump list of all installed dpkg packages to $FILENAME"
dpkg-query -W -f='${Package} ${Version}\n' | sort > $FILENAME
