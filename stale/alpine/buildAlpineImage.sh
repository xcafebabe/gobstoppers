#!/bin/bash

# Clone source code from Gliderlabs
if [ ! -d "docker-alpine" ]; then
  git clone https://github.com/gliderlabs/docker-alpine.git
fi

if [ -z "$ALPINE_VERSION" ]; then
  export ALPINE_VERSION="3.9"
fi

if [ -z "$ALPINE_CUSTOM_IMAGE" ]; then
  export ALPINE_CUSTOM_IMAGE="kafebob/rpi-alpine"
fi

# Using prepared builder image
cp builder/Dockerfile docker-alpine/builder
cd docker-alpine/

# build the builder image
sudo docker build -t alpine-builder builder

# Generate Alpine root filesystem
sudo docker run --rm --name alpine-build-v${ALPINE_VERSION} alpine-builder -s -t UTC -a armhf -r v${ALPINE_VERSION} -m http://dl-4.alpinelinux.org/alpine > ./versions/gliderlabs-${ALPINE_VERSION}/rootfs.tar.xz

# Package filesystem in your Alpine image
sudo docker build -t ${ALPINE_CUSTOM_IMAGE}:${ALPINE_VERSION} versions/gliderlabs-${ALPINE_VERSION}

# Remove alpine-builder
sudo docker rmi alpine-builder

# Builded ok
echo "Successfully built. Try:  sudo docker run --rm -it --entrypoint /bin/sh --name alpine2 ${ALPINE_CUSTOM_IMAGE}"
