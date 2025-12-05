# shellcheck shell=bash

export CONFIG_TOML="${CONFIG_TOML}"

export BUILD_AND_SYMLINK="${BUILD_AND_SYMLINK}"
export GET_CONFIG_VALUE="${GET_CONFIG_VALUE}"
export FIND_STALE_DEPENDENCY_GRAPH_NODES="${FIND_STALE_DEPENDENCY_GRAPH_NODES}"

cache_dir="$(CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" path:cache)"
eagerly_rebuild="$(CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" eagerly-rebuild)"

if test "${eagerly_rebuild:-}" = true; then
	CONFIG_TOML="${CONFIG_TOML}" \
		"${FIND_STALE_DEPENDENCY_GRAPH_NODES}" |
		CACHE_DIR="${cache_dir}" \
			"${BUILD_AND_SYMLINK}"
else
	while read -r node; do
		rm "${cache_dir}"/"${node}" >/dev/null 2>&1 || true
	done < <(CONFIG_TOML="${CONFIG_TOML}" \
		"${FIND_STALE_DEPENDENCY_GRAPH_NODES}")
fi
