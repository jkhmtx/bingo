# shellcheck shell=bash

set -euo pipefail

nix build '#' --out-link .mrx/cmd
mrx=.mrx/cmd/bin/mrx

"${mrx}" generate

dev_shell_paths_lst="$(mktemp)"
"${mrx}" build \
  >"${dev_shell_paths_lst}"

mapfile -t path_add_paths <"${dev_shell_paths_lst}"
rm "${dev_shell_paths_lst}"

if type PATH_add >/dev/null 2>&1; then
  PATH_add "${path_add_paths[@]}"
fi

watch_files_lst="$(mktemp)"
"${mrx}" find-watch-files \
  >"${watch_files_lst}"

mapfile -t watch_files <"${watch_files_lst}"
rm "${watch_files_lst}"

if type watch_file >/dev/null 2>&1; then
  watch_file "${watch_files[@]}"
fi

"${mrx}" refresh

"${mrx}" post >&2
