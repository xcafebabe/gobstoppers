FROM kafebob/rpi-alpine-base
COPY scripts/mkimage-alpine.bash scripts/apk-install /
RUN apk add --update apk-tools bash tzdata xz
ENTRYPOINT ["/mkimage-alpine.bash"]