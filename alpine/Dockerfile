ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

ARG TIMEZONE=UTC
ENV TZ=${TIMEZONE}

RUN apk update && \
    apk upgrade && \
    apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    apk del tzdata && \
    rm -rf /var/cache/apk/* /tmp/*

CMD ["sh"]