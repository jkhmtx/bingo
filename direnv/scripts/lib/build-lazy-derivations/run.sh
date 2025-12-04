# shellcheck shell=bash

export PREFIX="${PREFIX}"
export FIND_BINS="${FIND_BINS}"

export BUILD_AND_SYMLINK="${BUILD_AND_SYMLINK}"
export CACHE_DIR=${CACHE_DIR}
export SHELL_DIR="${SHELL_DIR}"

bin_dir="${SHELL_DIR}"/bin

root="$(git rev-parse --show-toplevel)"

rm -rf "${bin_dir}" >/dev/null 2>&1 || true
mkdir -p "${bin_dir}"

mapfile -t derivations < <(PREFIX="${PREFIX}" "${FIND_BINS}")
for derivation in "${derivations[@]}"; do
	cache="${CACHE_DIR}/${derivation}"
	path="${bin_dir}"/"${derivation}"

	cat <<EOF >"${path}"
cd ${root} || exit 1

if ! bash -n ${cache} >/dev/null >&2; then
	echo "${derivation}" | CACHE_DIR=${CACHE_DIR} ${BUILD_AND_SYMLINK}
fi

${cache} \${@}
EOF

	chmod +x "${path}"
done

echo "${bin_dir}"
