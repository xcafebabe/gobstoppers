FROM kafebob/rpi-alpine:3.6

ENV NVM_VERSION=v0.33.2 NODE_VERSION=v8.2.1 PROFILE=/home/node/.bashrc

RUN apk add --update --no-cache curl bash \
    ca-certificates openssl coreutils && \
    apk add --update --no-cache --virtual build-dependencies ncurses python2 \
    make gcc g++ libgcc linux-headers && \
    addgroup -g 1000 node && \
    adduser -u 1000 -G node -s /bin/bash -h /home/node -D node
  
USER node   
RUN cd /home/node && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash && \
    echo "#NVM Setup" >> $PROFILE && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $PROFILE && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> $PROFILE && \
    source $PROFILE && \
    nvm install -s $NODE_VERSION --fully-static && \
    rm -rf /home/node/.nvm/.cache/src/node-$NODE_VERSION

USER root
RUN apk del build-dependencies && \
    rm -rf /tmp/* /var/cache/apk/*