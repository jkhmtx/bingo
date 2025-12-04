# shellcheck shell=bash

export BIOME_JSONC="${BIOME_JSONC}"

biome_flags=(--config-path "${BIOME_JSONC}")

if ! test -v CI; then
  biome_flags+=(--fix)
fi

biome "${@}" "${biome_flags[@]}"
