# Inspired from https://github.com/Wonderfall/docker-nextcloud
FROM kafebob/rpi-nginx-php:latest

LABEL description="Nextcloud for Raspberry Pi" \
      maintainer="Luis Toubes <luis@toub.es>"

ARG NEXTCLOUD_VERSION=13.0.2
ARG NEXTCLOUD_GPG="2880 6A87 8AE4 23A2 8372  792E D758 99B9 A724 937A"
ARG NGINX_UID=1000
ARG NGINX_GID=1000

ENV TZ=Etc/UTC \
    DB_TYPE=sqlite3 \
    DB_NAME=nextcloud \
    DB_USER=nextcloud \
    DB_PASSWORD=password \
    DB_HOST=localhost \
    TRUSTED_DOMAINS="127.0.0.1" \
    ADMIN_USER=admin \
    ADMIN_PASSWORD=password

RUN apk -U upgrade \
    && apk add -t build-dependencies \
        gnupg \
        tar \
        build-base \
        autoconf \
        automake \
        pcre-dev \
        libtool \
        samba-dev \
        shadow \
    && apk add \
        php7-pear php7-dev php7-fileinfo \
        php7-sqlite3 php7-pdo_sqlite \
        libressl \
        ca-certificates \
        libsmbclient \
        tzdata \
    && pecl install \
        smbclient \
        apcu \
        redis \
    && mkdir -p /nextcloud/config /data /apps2 \
    && cd /tmp \
    && NEXTCLOUD_TARBALL="nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" \
    && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL} \
    && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL}.sha512 \
    && wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL}.asc \
    && wget -q https://nextcloud.com/nextcloud.asc \
    && echo "Verifying both integrity and authenticity of ${NEXTCLOUD_TARBALL}..." \
    && CHECKSUM_STATE=$(echo -n $(sha512sum -c ${NEXTCLOUD_TARBALL}.sha512) | tail -c 2) \
    && if [ "${CHECKSUM_STATE}" != "OK" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
    && gpg --import nextcloud.asc \
    && FINGERPRINT="$(LANG=C gpg --verify ${NEXTCLOUD_TARBALL}.asc ${NEXTCLOUD_TARBALL} 2>&1 \
    | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
    && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
    && if [ "${FINGERPRINT}" != "${NEXTCLOUD_GPG}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
    && echo "All seems good, now unpacking ${NEXTCLOUD_TARBALL}..." \
    && tar xjf ${NEXTCLOUD_TARBALL} --strip 1 -C /nextcloud \
    && update-ca-certificates \
    && usermod -u ${NGINX_UID} nginx \
    && groupmod -g ${NGINX_GID} nginx \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg || true \
    && mkdir /storage \
    && chown -R nginx:nginx /data /apps2 /nextcloud /storage

COPY ./rootfs/. /

VOLUME /data /apps2 /nextcloud/themes /nextcloud/config

WORKDIR /nextcloud

EXPOSE 80
