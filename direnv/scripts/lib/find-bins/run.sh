# shellcheck shell=bash

export FIND_GENERATED_NIX_RAW_ATTRSET="${FIND_GENERATED_NIX_RAW_ATTRSET}"

set -euo pipefail

"${FIND_GENERATED_NIX_RAW_ATTRSET}" |
  grep '/bin/' |
  while read -r attrname _; do
    echo "${attrname}"
  done
