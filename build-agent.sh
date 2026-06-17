#!/bin/bash
packer build -only "${BUILD_NAME:-ubuntu-22_04}.azure-arm.image" $TEMPLATES_DIR
