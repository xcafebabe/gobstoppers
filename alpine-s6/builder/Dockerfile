FROM alpine:latest
COPY scripts/mkimage-alpine.bash scripts/apk-install /
RUN apk add --update bash tzdata xz
ENTRYPOINT ["/mkimage-alpine.bash"]