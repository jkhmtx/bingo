# shellcheck shell=bash

export CONFIG_TOML="${CONFIG_TOML}"

export FIND_DEPENDENCY_GRAPH_EDGES="${FIND_DEPENDENCY_GRAPH_EDGES}"
export GENERATE_IGNORE_PATTERNS_FILE="${GENERATE_IGNORE_PATTERNS_FILE}"

ignore_patterns_file="$(CONFIG_TOML="${CONFIG_TOML}" "${GENERATE_IGNORE_PATTERNS_FILE}")"

CONFIG_TOML="${CONFIG_TOML}" \
  "${FIND_DEPENDENCY_GRAPH_EDGES}" |
  xargs -n 1 echo |
  grep --invert-match --file "${ignore_patterns_file}" |
  sort |
  uniq

rm "${ignore_patterns_file}"
