# Alpine Images

## Alpine Basic

In order to build your own Alpine Image for your Raspberry Pi based on `gliderlabs/alpine`

```
git clone https://github.com/xcafebabe/gobstoppers.git && \
cd gobstoppers/alpine && \
./buildAlpineImage.sh
```

By default is going to use as image name `kafebob/rpi-alpine` and as alpine version `3.9`

You can change these names by creating two environment variables

```
export ALPINE_VERSION=3.9  && \
export ALPINE_CUSTOM_IMAGE=kafebob/rpi-alpine
```

# Alpine Base

This image is based on `kafebob/rpi-alpine` but also includes [S6 overlay](https://github.com/just-containers/s6-overlay)

Either you could pull the image from Docker Hub

```
sudo docker pull kafebob/rpi-alpine-base
```

or you could buil it locally

```
sudo docker build -t kafebob/rpi-alpine-base:latest base
```
