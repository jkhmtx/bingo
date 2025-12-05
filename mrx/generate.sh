# shellcheck shell=bash

set -euo pipefail

CONFIG_TOML=mrx.toml

CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file package.nix 'generate-nix'

dev_shell_paths_lst="$(mktemp)"
CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file package.nix 'build-shell' \
  >"${dev_shell_paths_lst}"

mapfile -t path_add_paths <"${dev_shell_paths_lst}"
rm "${dev_shell_paths_lst}"

if type PATH_add >/dev/null 2>&1; then
  PATH_add "${path_add_paths[@]}"
fi

watch_files_lst="$(mktemp)"
CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file package.nix 'find-watch-files' \
  >"${watch_files_lst}"

mapfile -t watch_files <"${watch_files_lst}"
rm "${watch_files_lst}"

if type watch_file >/dev/null 2>&1; then
  watch_file "${watch_files[@]}"
fi

CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file package.nix 'handle-stale-dependency-graph-nodes'

CONFIG_TOML="${CONFIG_TOML}" \
  nix run --file package.nix 'post' >&2
