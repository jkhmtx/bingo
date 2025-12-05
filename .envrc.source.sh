# shellcheck shell=bash

set -euo pipefail

GENERATED_NIX=nix/generated.nix
PREFIX=.direnv

STATE_DIR="${PREFIX}"/state
LST_DIR="${STATE_DIR}"/allow
TEE_FILE_PREFIX="${LST_DIR}"

CACHE_DIR="${STATE_DIR}"/cache
SHELL_DIR="${PREFIX}"/shell

mkdir -p "${LST_DIR}"

DESTINATION="${GENERATED_NIX}" \
  TEE_FILE_PREFIX="${LST_DIR}" \
  nix run '#direnv.generate-nix-index' -- ':*main.nix'

CACHE_DIR="${CACHE_DIR}" \
  PREFIX="${PREFIX}" \
  SHELL_DIR="${SHELL_DIR}" \
  TEE_FILE_PREFIX="${LST_DIR}" \
  nix run '#direnv.build-shell' -- ':*main.nix' \
  >"${LST_DIR}"/dev-shell-paths.lst

mapfile -t path_add_paths <"${LST_DIR}"/dev-shell-paths.lst
rm "${LST_DIR}"/dev-shell-paths.lst

PATH_add "${path_add_paths[@]}"

IGNORE_PATTERNS_FILE="$(mktemp)"
echo "${GENERATED_NIX}" >"${IGNORE_PATTERNS_FILE}"

IGNORE_PATTERNS_FILE="${IGNORE_PATTERNS_FILE}" \
  TEE_FILE_PREFIX="${LST_DIR}" \
  nix run '#direnv.find-watch-files' -- ':*main.nix' \
  >"${STATE_DIR}"/watch_files.lst

mapfile -t watch_files <"${STATE_DIR}"/watch_files.lst
rm "${STATE_DIR}"/watch_files.lst

watch_file "${watch_files[@]}"

CACHE_DIR="${CACHE_DIR}" \
  GENERATED_NIX="${GENERATED_NIX}" \
  LST_DIR="${LST_DIR}" \
  PREFIX="${PREFIX}" \
  STATE_DIR="${STATE_DIR}" \
  TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
  nix run '#direnv.handle-stale-dependency-graph-nodes' -- ':*main.nix'

PREFIX="${PREFIX}" \
  TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
  nix run '#direnv.post' >&2
