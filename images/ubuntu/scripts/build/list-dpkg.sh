#!/bin/bash -e
################################################################################
##  File:  list-dpkg.sh
##  Desc:  List all installed dpkg packages
################################################################################
echo "Dump list of all installed dpkg packages to $FILEPATH"
dpkg-query -W -f='${Package} ${Version}\n' | sort > $FILEPATH
