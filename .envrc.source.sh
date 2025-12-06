# shellcheck shell=bash

set -euo pipefail

nix run '#mrx' -- generate

dev_shell_paths_lst="$(mktemp)"
nix run '#mrx' -- build \
  >"${dev_shell_paths_lst}"

mapfile -t path_add_paths <"${dev_shell_paths_lst}"
rm "${dev_shell_paths_lst}"

PATH_add "${path_add_paths[@]}"

watch_files_lst="$(mktemp)"
mrx find-watch-files \
  >"${watch_files_lst}"

mapfile -t watch_files <"${watch_files_lst}"
rm "${watch_files_lst}"

watch_file "${watch_files[@]}"

mrx refresh

mrx post >&2
