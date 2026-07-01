# Build args and base image
ARG ESPHOME_BUILD_VERSION=latest
FROM ghcr.io/bbusse/esphome-build:${ESPHOME_BUILD_VERSION}
LABEL maintainer="Björn Busse <bj.rn@baerlin.eu>"
LABEL org.opencontainers.image.source https://github.com/bbusse/compost-sensor

# Set up environment and user
ENV ARCH="x86_64" \
    USER="build" \
    WIFI_FALLBACK_SSID="esp32-sensors" \
    WIFI_FALLBACK_PASSPHRASE="secretpassphrase"

USER $USER

# Install dependencies and tools (cacheable)
RUN cd && . esphome/bin/activate && \
    pio --version && \
    pio -h && \
    pio boards && \
    esphome version

# Copy config and inject secrets (invalidate cache only on config change)
ARG ESPHOME_CFG
ARG WIFI_SSID
ARG WIFI_PASSPHRASE
ARG HA_API_KEY
ARG HA_OTA_PASSWORD
ENV ESPHOME_CFG=${ESPHOME_CFG} \
    HA_API_KEY=${HA_API_KEY} \
    HA_OTA_PASSWORD=${HA_OTA_PASSWORD} \
    WIFI_SSID=${WIFI_SSID} \
    WIFI_PASSPHRASE=${WIFI_PASSPHRASE}

COPY ${ESPHOME_CFG} /home/$USER
RUN cd && . esphome/bin/activate && \
    echo "ha_api_key: $HA_API_KEY" >> secrets.yaml && \
    echo "ha_ota_password: $HA_OTA_PASSWORD" >> secrets.yaml && \
    echo "wifi_ssid: $WIFI_SSID" >> secrets.yaml && \
    echo "wifi_passphrase: $WIFI_PASSPHRASE" >> secrets.yaml && \
    echo "wifi_fallback_ssid: $WIFI_FALLBACK_SSID" >> secrets.yaml && \
    echo "wifi_fallback_passphrase: $WIFI_FALLBACK_PASSPHRASE" >> secrets.yaml && \
    esphome compile ${ESPHOME_CFG}
