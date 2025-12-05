# shellcheck shell=bash

set -euo pipefail

CONFIG_TOML=mrx.toml

CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file direnv/package.nix 'generate-nix'

dev_shell_paths_lst="$(mktemp)"
CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file direnv/package.nix 'build-shell' \
  >"${dev_shell_paths_lst}"

mapfile -t path_add_paths <"${dev_shell_paths_lst}"
rm "${dev_shell_paths_lst}"

PATH_add "${path_add_paths[@]}"

watch_files_lst="$(mktemp)"
CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file direnv/package.nix 'find-watch-files' \
  >"${watch_files_lst}"

mapfile -t watch_files <"${watch_files_lst}"
rm "${watch_files_lst}"

watch_file "${watch_files[@]}"

CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file direnv/package.nix 'handle-stale-dependency-graph-nodes'

CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file direnv/package.nix 'post' >&2
