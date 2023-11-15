ARG ESPHOME_BUILD_VERSION=latest
FROM bbusse/esphome-build:${ESPHOME_BUILD_VERSION}
LABEL maintainer="Björn Busse <bj.rn@baerlin.eu>"
LABEL org.opencontainers.image.source https://github.com/bbusse/compost-sensor

ENV ARCH="x86_64" \
    USER="build" \

USER $USER

RUN cd && ls -al && \
    . esphome/bin/activate && \
    esphome build
