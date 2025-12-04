# shellcheck shell=bash

export DRV_NAME="${DRV_NAME}"
export TEE_FILE_PREFIX="${TEE_FILE_PREFIX}"

mkdir -p "${TEE_FILE_PREFIX}"

"${DRV_NAME}" "${@}" | tee "${TEE_FILE_PREFIX}/${DRV_NAME}"
