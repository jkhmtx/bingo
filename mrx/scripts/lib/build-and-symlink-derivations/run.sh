# shellcheck shell=bash

export CONFIG_TOML="${CONFIG_TOML}"
export GET_CONFIG_VALUE="${GET_CONFIG_VALUE}"

root="$(CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" path:config)"

cd "${root}" || exit 1

export CACHE_DIR="${CACHE_DIR}"

mkdir -p "${CACHE_DIR}"

mapfile -t derivations < <(cat - | xargs printf '#%s\n')

mapfile -t out_paths < <(nix build --print-build-logs --print-out-paths "${derivations[@]}")

for path in "${out_paths[@]}"; do
	derivation="${path/nix\/store\/*-/}"

	ln -fs "${path}/bin/${derivation}" "${CACHE_DIR}"/"${derivation}"
done
