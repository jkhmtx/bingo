# shellcheck shell=bash

export CONFIG_TOML="${CONFIG_TOML}"
export GET_CONFIG_VALUE="${GET_CONFIG_VALUE}"

export BUILD_AND_SYMLINK="${BUILD_AND_SYMLINK}"
export FIND_BINS="${FIND_BINS}"

bin_dir="$(CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" path:bin)"
cache_dir="$(CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" path:cache)"
installables="$(CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" installables)"
root="$(CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" path:config)"

if test -s default.nix || test -n "${installables:-}"; then
  out_paths="$(mktemp)"

  nix build \
    --stdin \
    --json \
    --no-link \
    <<<"${installables}" |
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

rm -rf "${bin_dir}" >/dev/null 2>&1 || true
mkdir -p "${bin_dir}"

mapfile -t derivations < <(CONFIG_TOML="${CONFIG_TOML}" "${FIND_BINS}")
for derivation in "${derivations[@]}"; do
  cache="${cache_dir}/${derivation}"
  path="${bin_dir}"/"${derivation}"

  cat <<EOF >"${path}"
cd ${root} || exit 1

if ! bash -n ${cache} >/dev/null >&2; then
	echo "${derivation}" | CACHE_DIR=${cache_dir} ROOT=${root} ${BUILD_AND_SYMLINK}
fi

${cache} \${@}
EOF

  chmod +x "${path}"
done

echo "${bin_dir}"
printf '%s\n' "${paths[@]}"
