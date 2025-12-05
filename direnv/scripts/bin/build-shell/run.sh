# shellcheck shell=bash

export BIN_DIR="${BIN_DIR}"
export CACHE_DIR=${CACHE_DIR}
export PREFIX="${PREFIX}"
export ROOT="${ROOT}"

export BUILD_AND_SYMLINK="${BUILD_AND_SYMLINK}"
export FIND_BINS="${FIND_BINS}"

if test -s default.nix || test -n "${INSTALLABLES:-}"; then
  out_paths="$(mktemp)"

  nix build \
    --stdin \
    --json \
    --no-link \
    <<<"${INSTALLABLES}" |
    jq --raw-output '
      .[].outputs 
      | if .out then 
          "\(.out)/bin" 
        elif .bin then 
          .bin
        else 
          error("Output does not have a valid bin path")
        end' \
      >"${out_paths}"

  mapfile -t paths <"${out_paths}"
  rm "${out_paths}"
fi

rm -rf "${BIN_DIR}" >/dev/null 2>&1 || true
mkdir -p "${BIN_DIR}"

mapfile -t derivations < <(PREFIX="${PREFIX}" "${FIND_BINS}" "${@}")
for derivation in "${derivations[@]}"; do
  cache="${CACHE_DIR}/${derivation}"
  path="${BIN_DIR}"/"${derivation}"

  cat <<EOF >"${path}"
cd ${ROOT} || exit 1

if ! bash -n ${cache} >/dev/null >&2; then
	echo "${derivation}" | CACHE_DIR=${CACHE_DIR} ${BUILD_AND_SYMLINK}
fi

${cache} \${@}
EOF

  chmod +x "${path}"
done

# If sourced by PATH_add in order,
# any derivation in a symlinkJoin, built via '${INSTALLABLES}',
# will be in preferential order in PATH, and shadow the cache-aside
# implementation. This means that opting out of caching is possible
# on a per-exe basis.
echo "${BIN_DIR}"
printf '%s/bin\n' "${paths[@]}"
