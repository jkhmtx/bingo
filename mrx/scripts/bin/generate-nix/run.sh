# shellcheck shell=bash

function write_file() {
  local prefix="${1}"
  tmp="$(mktemp)"

  {
    echo '{'
    CONFIG_TOML="${CONFIG_TOML}" \
      "${FIND_GENERATED_NIX_RAW_ATTRSET}" |
      while read -r attrname path; do
        echo "  ${attrname} = ${prefix}${path};"
      done
    echo '}'
  } >"${tmp}"

  echo "${tmp}"
}

set -E

export CONFIG_TOML="${CONFIG_TOML}"
export FIND_GENERATED_NIX_RAW_ATTRSET="${FIND_GENERATED_NIX_RAW_ATTRSET}"
export GET_CONFIG_VALUE="${GET_CONFIG_VALUE}"

destination="$(CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" generated-out-path)"

config_path="$(realpath "${CONFIG_TOML}")"
config_dir="$(dirname "${config_path}")"

mkdir -p "$(dirname "${config_dir}"/"${destination}")"

# Add a dummy slash to prevent grep from failing
num_slashes=$(echo "/${destination}" | grep --only-matching '/' | wc -l)

prefix=''
# Account for the extra slash by subtracting one
for ((i = 0; i < (num_slashes - 1); i++)); do
  prefix="${prefix}../"
done

tmp="$(write_file "${prefix}" || true)"

if test -s "${tmp}"; then
  mv "${tmp}" "${destination}"
else
  echo "ERROR: '${destination}' generation failed. Rolling back..."
  exit 1
fi
