# shellcheck shell=bash

export CONFIG_TOML="${CONFIG_TOML}"

case "${1}" in
entrypoint)
  tq --raw --file "${CONFIG_TOML}" entrypoint
  ;;
*)
  echo "Config value '${1}' is invalid" >&2
  exit 1
  ;;
esac
