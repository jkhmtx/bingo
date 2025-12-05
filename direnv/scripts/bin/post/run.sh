# shellcheck shell=bash

export CONFIG_TOML="${CONFIG_TOML}"
export FIND_BINS="${FIND_BINS}"

function indent() {
  cat - | sed 's/^/  /'
}

echo
echo "The following commands are available in your shell:"
echo
CONFIG_TOML="${CONFIG_TOML}" \
  "${FIND_BINS}" | indent
echo
