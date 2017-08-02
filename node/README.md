# Alpine Node Images

## Node Image

In order to build your own Node Image for your Raspberry Pi based on `gliderlabs/alpine`

```
git clone https://github.com/xcafebabe/gobstoppers.git && \
cd gobstoppers/node && \
sudo docker build -t kafebob/rpi-alpine-node:latest .
```

Be patient is going to take a while.

By default is going to use as image name `kafebob/rpi-alpine-node` and as tag version `latest`

You can change these names creating two environment variables

```
export IMAGE_VERSION=8.2.1  && \
export IMAGE_NAME=kafebob/rpi-alpine-node
```

If you just want to use latest image available, pull a copy from DockerHub

```
sudo docker pull kafebob/rpi-alpine-node:latest
```
