# shellcheck shell=bash

export CACHE_DIR="${CACHE_DIR}"
export CONFIG_TOML="${CONFIG_TOML}"
export GENERATED_NIX="${GENERATED_NIX}"
export LST_DIR="${LST_DIR}"
export PREFIX="${PREFIX}"
export ROOT="${ROOT}"
export STATE_DIR="${STATE_DIR}"
export TEE_FILE_PREFIX="${TEE_FILE_PREFIX}"

export BUILD_AND_SYMLINK="${BUILD_AND_SYMLINK}"
export FIND_DEPENDENCY_GRAPH_EDGES="${FIND_DEPENDENCY_GRAPH_EDGES}"
export FIND_GENERATED_NIX_RAW_ATTRSET="${FIND_GENERATED_NIX_RAW_ATTRSET}"
export MTIME_DATABASE="${MTIME_DATABASE}"

GRAPH_DIR="${PREFIX}"/graph
MTIME_DIR="${STATE_DIR}"/mtime
STALE_GRAPH_NODES_LST="${LST_DIR}"/stale-graph-nodes.lst

PARENTS_BY_CHILD_PATH_GRAPH_DIR="${GRAPH_DIR}"/parents-by-child-path

function push() {
	local path="${PARENTS_BY_CHILD_PATH_GRAPH_DIR}/${1}"
	mkdir -p "$(dirname "${path}")"
	touch "${path}"
	if test -v 2; then
		echo "${2}" >>"${path}"
	fi
}

function list_ancestors_recursive() {
	local path="${PARENTS_BY_CHILD_PATH_GRAPH_DIR}/${1}"
	if ! test -s "${path}"; then
		return
	fi

	while read -r parent; do
		echo "${parent}"
		list_ancestors_recursive "${parent}"
	done <"${path}"
}

rm -rf "${PARENTS_BY_CHILD_PATH_GRAPH_DIR}" >/dev/null 2>&1 || true

DEPENDENCY_GRAPH_EDGES_LST="${LST_DIR}"/dependency-graph-edges.lst

CONFIG_TOML="${CONFIG_TOML}" \
	ROOT="${ROOT}" \
	TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
	"${FIND_DEPENDENCY_GRAPH_EDGES}" "${@}" \
	>"${DEPENDENCY_GRAPH_EDGES_LST}"

while read -r parent child; do
	if echo "${parent}" | grep -q "${GENERATED_NIX}"; then
		continue
	fi

	if test -n "${child}"; then
		push "${child}" "${parent}"
	else
		push "${parent}"
	fi
done <"${DEPENDENCY_GRAPH_EDGES_LST}"

mapfile -t files < <(find "${PARENTS_BY_CHILD_PATH_GRAPH_DIR}" -type f)

declare -A nodes

raw_attrs="$("${FIND_GENERATED_NIX_RAW_ATTRSET}" "${@}")"

while read -r attrname path; do
	nodes["${path}"]="${attrname}"
done <<<"${raw_attrs}"

{
	for file in "${files[@]}"; do
		file="${file##"${PARENTS_BY_CHILD_PATH_GRAPH_DIR}/"}"
		if test -n "$(echo "${file}" | MTIME_DIR="${MTIME_DIR}" "${MTIME_DATABASE}")"; then
			mapfile -t ancestors < <(list_ancestors_recursive "${file}")

			for ancestor in "${file}" "${ancestors[@]}"; do
				if test -v nodes["${ancestor}"]; then
					echo "${nodes["${ancestor}"]}"
					unset "nodes[${ancestor}]"
				fi
			done
		fi
	done
} >"${STALE_GRAPH_NODES_LST}"

if test "${__TOOL__EAGERLY_REBUILD:-}" = true; then
	CACHE_DIR="${CACHE_DIR}" \
		"${BUILD_AND_SYMLINK}" \
		<"${STALE_GRAPH_NODES_LST}"
else
	while read -r node; do
		rm "${CACHE_DIR}"/"${node}" >/dev/null 2>&1 || true
	done <"${STALE_GRAPH_NODES_LST}"
fi
