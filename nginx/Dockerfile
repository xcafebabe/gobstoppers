FROM kafebob/rpi-alpine-base:latest

LABEL maintainer="Luis Toubes <luis@toub.es>"

# environment
ENV NGINX_DH_SIZE 2048
ENV NGINX_SSL_SUBJECT /C=US/ST=MN/L=Barcelona/O=TrafficNow/OU=Local Server/CN=*
ENV NGINX_ENABLE_SSL 0

ENV NGINX_VERSION 1.13.8
ENV NGINX_DIFFIE_HELLMAN off
ENV NGINX_SERVERNAME ""


# packages & configure
RUN apk update && apk --no-cache add nginx && \
    mkdir -p \
      /var/lib/nginx \
      /etc/nginx/conf.d \
      /etc/nginx/hosts.d \
      /etc/nginx/keys && \
    rm -rf /etc/nginx/conf.d/* /etc/nginx/nginx.conf /etc/nginx/keys/* /var/lib/nginx/run && \
    # forward request and error logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# copy root filesystem
COPY ./src/rootfs/. /

# external
EXPOSE 80 443
WORKDIR /var/www

# Expose volumes
VOLUME ["/etc/nginx/conf.d", "/etc/nginx/certs", "/var/www"]

# Expose port
EXPOSE 80 443

STOPSIGNAL SIGTERM

# No need CMD or ENTRYPOINT, nginx is started as a service by S6