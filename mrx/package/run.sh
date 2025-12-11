# shellcheck shell=bash

export BUILD_AND_SYMLINK="${BUILD_AND_SYMLINK}"
export BUILD_SHELL="${BUILD_SHELL}"
export GENERATE_NIX="${GENERATE_NIX}"
export HANDLE_STALE_DEPENDENCY_GRAPH_NODES="${HANDLE_STALE_DEPENDENCY_GRAPH_NODES}"
export PACKAGE="${PACKAGE}"

export CONFIG_TOML=mrx.toml

case "${1}" in
build) "${BUILD_SHELL}" ;;
cache-build) "${BUILD_AND_SYMLINK}" ;;
find-watch-files) "${PACKAGE}" show --watch-files ;;
generate) "${GENERATE_NIX}" ;;
hook) "${PACKAGE}" hook ;;
refresh) "${HANDLE_STALE_DEPENDENCY_GRAPH_NODES}" ;;
*)
  echo "ERR: Unrecognized command ${1}"
  exit 1
  ;;
esac
