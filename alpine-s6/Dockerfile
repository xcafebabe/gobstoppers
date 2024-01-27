ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

ARG TIMEZONE=UTC
ENV TZ=${TIMEZONE}

RUN echo "http://dl-4.alpinelinux.org/alpine/v${ALPINE_VERSION}/community/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/v${ALPINE_VERSION}/testing/" >> /etc/apk/repositories

# Update packages and install necessary tools
RUN apk update && \
    apk upgrade && \
    apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    apk del tzdata && \
    rm -rf /var/cache/apk/* /tmp/*

# Default command to run when the container starts
CMD ["sh"]