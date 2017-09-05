# Alpine Node Images

## Node Image

In order to build your own Node Image for your Raspberry Pi based on `gliderlabs/alpine`

```
git clone https://github.com/xcafebabe/gobstoppers.git && \
cd gobstoppers/nvm && \
sudo docker build -t kafebob/rpi-alpine-nvm:latest .
```

Be patient is going to take a while.

By default is going to use as image name `kafebob/rpi-alpine-nvm` and as tag version `latest`

You can change these names creating two environment variables

```
export IMAGE_VERSION=8.4.0  && \
export IMAGE_NAME=kafebob/rpi-alpine-nvm
```

If you just want to use latest image available, pull a copy from DockerHub

```
sudo docker pull kafebob/rpi-alpine-nvm:latest
```
