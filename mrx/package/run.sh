# shellcheck shell=bash

export BUILD_AND_SYMLINK="${BUILD_AND_SYMLINK}"
export BUILD_SHELL="${BUILD_SHELL}"
export FIND_WATCH_FILES="${FIND_WATCH_FILES}"
export GENERATE_NIX="${GENERATE_NIX}"
export HANDLE_STALE_DEPENDENCY_GRAPH_NODES="${HANDLE_STALE_DEPENDENCY_GRAPH_NODES}"
export POST="${POST}"

export CONFIG_TOML=mrx.toml

case "${1}" in
cache-build) "${BUILD_AND_SYMLINK}" ;;
build) "${BUILD_SHELL}" ;;
find-watch-files) "${FIND_WATCH_FILES}" ;;
generate) "${GENERATE_NIX}" ;;
post) "${POST}" ;;
refresh) "${HANDLE_STALE_DEPENDENCY_GRAPH_NODES}" ;;
*)
  echo "ERR: Unrecognized command ${1}"
  exit 1
  ;;
esac
