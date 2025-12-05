# shellcheck shell=bash

set -euo pipefail

CONFIG_TOML=mrx.toml
DERIVATIONS=(':*main.nix' ':!:direnv/*')
GENERATED_NIX=nix/generated.nix

# Inferable from location of config
ROOT="$(git rev-parse --show-toplevel)"

# TODO: Move to internal
PREFIX=__TOOL__
STATE_DIR="${PREFIX}"/state
LST_DIR="${STATE_DIR}"/allow
TEE_FILE_PREFIX="${LST_DIR}"
CACHE_DIR="${STATE_DIR}"/cache
BIN_DIR="${PREFIX}"/bin

mkdir -p "${LST_DIR}"

DESTINATION="${GENERATED_NIX}" \
  ROOT="${ROOT}" \
  TEE_FILE_PREFIX="${LST_DIR}" \
  nix run --file direnv/package.nix 'generate-nix' -- "${DERIVATIONS[@]}"

BIN_DIR="${BIN_DIR}" \
  CACHE_DIR="${CACHE_DIR}" \
  INSTALLABLES='#shell' \
  PREFIX="${PREFIX}" \
  ROOT="${ROOT}" \
  TEE_FILE_PREFIX="${LST_DIR}" \
  nix run --file direnv/package.nix 'build-shell' -- "${DERIVATIONS[@]}" \
  >"${LST_DIR}"/dev-shell-paths.lst

mapfile -t path_add_paths <"${LST_DIR}"/dev-shell-paths.lst
rm "${LST_DIR}"/dev-shell-paths.lst

PATH_add "${path_add_paths[@]}"

IGNORE_PATTERNS_FILE="$(mktemp)"
echo "${GENERATED_NIX}" >"${IGNORE_PATTERNS_FILE}"

CONFIG_TOML="${CONFIG_TOML}" \
  IGNORE_PATTERNS_FILE="${IGNORE_PATTERNS_FILE}" \
  ROOT="${ROOT}" \
  TEE_FILE_PREFIX="${LST_DIR}" \
  nix run --file direnv/package.nix 'find-watch-files' -- "${DERIVATIONS[@]}" \
  >"${STATE_DIR}"/watch_files.lst

mapfile -t watch_files <"${STATE_DIR}"/watch_files.lst
rm "${STATE_DIR}"/watch_files.lst

watch_file "${watch_files[@]}"

CACHE_DIR="${CACHE_DIR}" \
  CONFIG_TOML="${CONFIG_TOML}" \
  GENERATED_NIX="${GENERATED_NIX}" \
  LST_DIR="${LST_DIR}" \
  PREFIX="${PREFIX}" \
  ROOT="${PWD}" \
  STATE_DIR="${STATE_DIR}" \
  TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
  nix run --file direnv/package.nix 'handle-stale-dependency-graph-nodes' -- "${DERIVATIONS[@]}"

PREFIX="${PREFIX}" \
  TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
  nix run --file direnv/package.nix 'post' -- "${DERIVATIONS[@]}" >&2
