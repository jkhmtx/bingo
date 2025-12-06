# shellcheck shell=bash

set -E

function write_file() {
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

export CONFIG_TOML="${CONFIG_TOML}"
export FIND_GENERATED_NIX_RAW_ATTRSET="${FIND_GENERATED_NIX_RAW_ATTRSET}"
export GET_CONFIG_VALUE="${GET_CONFIG_VALUE}"

destination="$(CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" generated-out-path)"

mkdir -p "$(dirname "${destination}")"

num_slashes=$(echo "${destination}" | grep --only-matching '/' | wc -l)

prefix=''
for ((i = 0; i < num_slashes; i++)); do
  prefix="${prefix}../"
done

tmp="$(write_file || true)"

if test -s "${tmp}"; then
  mv "${tmp}" "${destination}"
else
  echo "ERROR: '${destination}' generation failed. Rolling back..."
  exit 1
fi
