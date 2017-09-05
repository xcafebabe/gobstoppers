FROM kafebob/rpi-alpine-node
MAINTAINER Luis Toubes <luis@toub.es>

RUN apk add --update --no-cache git && \
    git clone https://github.com/huytd/agar.io-clone.git agario && \
    cd agario && \
    npm install && npm cache clean --force

WORKDIR /agario

EXPOSE 3000

CMD [ "npm", "start"]