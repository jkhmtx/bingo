# shellcheck shell=bash

export ROOT="${ROOT}"

cd "${ROOT}" || exit 1

set -euo pipefail

export CACHE_DIR="${CACHE_DIR}"

mkdir -p "${CACHE_DIR}"

mapfile -t derivations < <(cat - | xargs printf '#%s\n')

mapfile -t out_paths < <(nix build --print-build-logs --print-out-paths "${derivations[@]}")

for path in "${out_paths[@]}"; do
	derivation="${path/nix\/store\/*-/}"

	ln -fs "${path}/bin/${derivation}" "${CACHE_DIR}"/"${derivation}"
done
