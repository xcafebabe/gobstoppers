FROM kafebob/rpi-alpine-base:3.6
MAINTAINER Luis Toubes <luis@toub.es>

ENV NVM_VERSION=v0.33.2 NODE_VERSION=v8.2.1 PROFILE=/root/.bashrc

RUN apk add --update --no-cache curl bash \
    ca-certificates openssl coreutils && \
    apk add --update --no-cache --virtual build-dependencies ncurses python2 \
    make gcc g++ libgcc linux-headers && \
    cd /root && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash && \
    echo "#NVM Setup" >> $PROFILE && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $PROFILE && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> $PROFILE && \
    source $PROFILE && \
    nvm install -s $NODE_VERSION --fully-static && \
    rm -rf /root/.nvm/.cache/src/node-$NODE_VERSION && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/cache/apk/*