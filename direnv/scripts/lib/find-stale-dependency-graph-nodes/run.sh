# shellcheck shell=bash

export FIND_GENERATED_NIX_RAW_ATTRSET="${FIND_GENERATED_NIX_RAW_ATTRSET}"
export GENERATED_NIX="${GENERATED_NIX}"
export MTIME_DIR="${MTIME_DIR}"
export MTIME_DATABASE="${MTIME_DATABASE}"
export PREFIX="${PREFIX}"

GRAPH_DIR="${PREFIX}"/graph

rm -rf "${GRAPH_DIR}" >/dev/null 2>&1 || true

function push() {
	local path="${GRAPH_DIR}/${1}"
	mkdir -p "$(dirname "${path}")"
	touch "${path}"
	if test -v 2; then
		echo "${2}" >>"${path}"
	fi
}

while read -r parent child; do
	if echo "${parent}" | grep -q "${GENERATED_NIX}"; then
		continue
	fi

	if test -n "${child}"; then
		push "${child}" "${parent}"
	else
		push "${parent}"
	fi
done

mapfile -t files < <(find "${GRAPH_DIR}" -type f)

declare -A nodes

raw_attrs="$("${FIND_GENERATED_NIX_RAW_ATTRSET}")"

while read -r attrname path; do
	nodes["${path}"]="${attrname}"
done <<<"${raw_attrs}"

function list_ancestors_recursive() {
	local path="${GRAPH_DIR}/${1}"
	if ! test -s "${path}"; then
		return
	fi

	while read -r parent; do
		echo "${parent}"
		list_ancestors_recursive "${parent}"
	done <"${path}"
}

for file in "${files[@]}"; do
	file="${file##"${GRAPH_DIR}/"}"
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
