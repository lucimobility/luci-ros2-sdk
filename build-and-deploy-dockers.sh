#!/bin/bash

while getopts 'dr' flag;
do
    case "${flag}" in
        d) development=true;;
        r) release=true;;
    esac
done

REGISTRY=ghcr.io/lucimobility
# Links each image to this repo on GitHub, which is where GHCR takes its visibility and access from
SOURCE_LABEL=org.opencontainers.image.source=https://github.com/lucimobility/luci-ros2-sdk

# Get current path of this file
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

if [ "$development" = true ]; then
    echo "Development building..."
    cd $parent_path/development
    # Build development image 
    docker build --label $SOURCE_LABEL -t $REGISTRY/luci-sdk-development-image:latest .
    # Push development image to GHCR
    docker push $REGISTRY/luci-sdk-development-image:latest
fi

if [ "$release" = true ]; then
    echo "Release building..."
    cd $parent_path/release
    # Build release image 
    docker build --label $SOURCE_LABEL -t $REGISTRY/luci-ros2-sdk:latest .
    # Push release image to GHCR
    docker push $REGISTRY/luci-ros2-sdk:latest
fi
