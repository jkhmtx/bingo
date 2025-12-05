# shellcheck shell=bash

export FIND_DEPENDENCY_GRAPH_EDGES="${FIND_DEPENDENCY_GRAPH_EDGES}"
export IGNORE_PATTERNS_FILE="${IGNORE_PATTERNS_FILE}"
export TEE_FILE_PREFIX="${TEE_FILE_PREFIX}"

TEE_FILE_PREFIX="${TEE_FILE_PREFIX}" \
  "${FIND_DEPENDENCY_GRAPH_EDGES}" "${@}" |
  xargs -n 1 echo |
  grep --invert-match --file "${IGNORE_PATTERNS_FILE}" |
  sort |
  uniq
