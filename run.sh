#!/usr/bin/env bash

set -euo pipefail

export CONTAINER="${VARIANT}"
export VERBOSE=1

script_name=$(basename "$0")
readonly script_name
readonly firmware_path="/home/build/.esphome/build/${VARIANT}/.pioenvs/${VARIANT}/firmware.bin"
readonly target_firmware_file=firmware-"${VARIANT}".bin

log() {
    if (( 1=="${VERBOSE}" )); then
        echo "$@" >&2
    fi

    logger -p user.notice -t "${script_name}" "$@"
}

error() {
    echo "$@" >&2
    logger -p user.error -t "${script_name}" "$@"
}

if [[ -z $(which podman) ]]; then
    if [[ -z $(which docker) ]]; then
        error "Could not find container executor."
        error "Install either podman or docker"
        exit 1
    else
        executor=docker
        log "Using ${executor} to run ${CONTAINER}"
    fi
else
    executor=podman
    log "Using ${executor} to run ${CONTAINER}"
fi

log "Building container"
${executor} build . -t "${CONTAINER}" --build-arg-file=argfile.conf --build-arg ESPHOME_CFG="${VARIANT}.yaml"

log "Running container"
${executor} run -dt localhost/"${VARIANT}"

log "Extracting firmware from container"
${executor} cp $(podman ps | awk '/'${VARIANT}'/ {print $1}' | tail -n1):${firmware_path} "${target_firmware_file}"

log "Stopping container"
${executor} stop $(podman ps | awk '/'${VARIANT}'/ {print $1}' | tail -n1)
