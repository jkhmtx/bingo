# shellcheck shell=bash

set -euo pipefail

PREFIX=.direnv

STATE_DIR="${PREFIX}"/state
LST_DIR="${STATE_DIR}"/allow
TEE_FILE_PREFIX="${LST_DIR}"

DEV_SHELL_PATHS_LST="${LST_DIR}"/dev-shell-paths.lst
SHELL_DIR="${PREFIX}"/shell
WATCH_FILES_LST="${LST_DIR}"/watch-files.lst

mkdir -p "${LST_DIR}"

DEV_SHELL_PATHS_LST="${DEV_SHELL_PATHS_LST}" \
  LST_DIR="${LST_DIR}" \
  PREFIX="${PREFIX}" \
  SHELL_DIR="${SHELL_DIR}" \
  STATE_DIR="${STATE_DIR}" \
  TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
  WATCH_FILES_LST="${WATCH_FILES_LST}" \
  nix run '#direnv.pre'

while read -r path; do
  PATH_add "${path}"
done <"${DEV_SHELL_PATHS_LST}"

while read -r path; do
  watch_file "${path}"
done <"${WATCH_FILES_LST}"

PREFIX="${PREFIX}" \
  TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
  nix run '#direnv.post' >&2
