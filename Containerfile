ARG ESPHOME_BUILD_VERSION=latest
FROM ghcr.io/bbusse/esphome-build:${ESPHOME_BUILD_VERSION}
LABEL maintainer="Björn Busse <bj.rn@baerlin.eu>"
LABEL org.opencontainers.image.source https://github.com/bbusse/compost-sensor

ENV ARCH="x86_64" \
    USER="build" \
    HA_API_PASSWORD="secret" \
    HA_OTA_PASSWORD="secret" \
    WIFI_SSID="unknown" \
    WIFI_PASSPHRASE="secretpassphrase" \
    WIFI_FALLBACK_SSID="compost-0" \
    WIFI_FALLBACK_PASSPHRASE="secretipassphrase"

USER $USER

RUN cd && ls -al && \
    . esphome/bin/activate && \
    curl -O https://raw.githubusercontent.com/bbusse/esphome-cfg/main/compost-0.yaml && \
    echo "ha_api_password: $HA_API_PASSWORD" >> secrets.yaml && \
    echo "ha_ota_password: $HA_OTA_PASSWORD" >> secrets.yaml && \
    echo "wifi_ssid: $WIFI_SSID" >> secrets.yaml && \
    echo "wifi_passphrase: $WIFI_PASSPHRASE" >> secrets.yaml && \
    echo "wifi_fallback_ssid: $WIFI_FALLBACK_SSID" >> secrets.yaml && \
    echo "wifi_fallback_passphrase: $WIFI_FALLBACK_PASSPHRASE" >> secrets.yaml && \
    pio --version &&\
    pio -h &&\
    pio boards && \
    pio upgrade &&\
    esphome version &&\
    esphome compile compost-0.yaml
