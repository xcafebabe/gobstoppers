FROM kafebob/rpi-alpine:3.9
LABEL maintainer="Luis Toubes <luis@toub.es>"

COPY rootfs /
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.22.0.0/s6-overlay-armhf.tar.gz /tmp/s6-overlay.tar.gz

RUN apk --update --no-cache add curl vim nano && \
    tar xvfz /tmp/s6-overlay.tar.gz -C /

ENTRYPOINT ["/init"]
CMD []