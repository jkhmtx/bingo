# shellcheck shell=bash

set -euo pipefail

ENTRYPOINT=package.nix
GENERATED_NIX=nix/root.nix
PREFIX=__TOOL__

STATE_DIR="${PREFIX}"/state
LST_DIR="${STATE_DIR}"/lst
TEE_FILE_PREFIX="${LST_DIR}"

CACHE_DIR="${STATE_DIR}"/cache
BIN_DIR="${PREFIX}"/bin

mkdir -p "${LST_DIR}"

derivations=(':*main.nix')

DESTINATION="${GENERATED_NIX}" \
  ROOT="${PWD}" \
  TEE_FILE_PREFIX="${LST_DIR}" \
  nix run --file package.nix 'generate-nix' -- "${derivations[@]}"

BIN_DIR="${BIN_DIR}" \
  CACHE_DIR="${CACHE_DIR}" \
  PREFIX="${PREFIX}" \
  ROOT="${PWD}" \
  TEE_FILE_PREFIX="${LST_DIR}" \
  nix run --file package.nix 'build-shell' -- "${derivations[@]}" \
  >"${LST_DIR}"/dev-shell-paths.lst

mapfile -t path_add_paths <"${LST_DIR}"/dev-shell-paths.lst
rm "${LST_DIR}"/dev-shell-paths.lst

if type PATH_add >/dev/null 2>&1; then
  PATH_add "${path_add_paths[@]}"
fi

IGNORE_PATTERNS_FILE="$(mktemp)"
echo "${GENERATED_NIX}" >"${IGNORE_PATTERNS_FILE}"

ENTRYPOINT="${ENTRYPOINT}" \
  IGNORE_PATTERNS_FILE="${IGNORE_PATTERNS_FILE}" \
  ROOT="${PWD}" \
  TEE_FILE_PREFIX="${LST_DIR}" \
  nix run --file package.nix 'find-watch-files' -- "${derivations[@]}" \
  >"${STATE_DIR}"/watch_files.lst

mapfile -t watch_files <"${STATE_DIR}"/watch_files.lst
rm "${STATE_DIR}"/watch_files.lst

if type watch_file >/dev/null 2>&1; then
  watch_file "${watch_files[@]}"
fi

CACHE_DIR="${CACHE_DIR}" \
  ENTRYPOINT="${ENTRYPOINT}" \
  GENERATED_NIX="${GENERATED_NIX}" \
  LST_DIR="${LST_DIR}" \
  PREFIX="${PREFIX}" \
  ROOT="${PWD}" \
  STATE_DIR="${STATE_DIR}" \
  TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
  nix run --file package.nix 'handle-stale-dependency-graph-nodes' -- "${derivations[@]}"

PREFIX="${PREFIX}" \
  TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
  nix run --file package.nix 'post' -- "${derivations[@]}" >&2
