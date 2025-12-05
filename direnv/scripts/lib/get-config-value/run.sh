# shellcheck shell=bash

export CONFIG_TOML="${CONFIG_TOML}"

dir="$(dirname "$(realpath "${CONFIG_TOML}")")"

case "${1}" in
entrypoint)
  entrypoint="$(tq --raw --file "${CONFIG_TOML}" entrypoint 2>/dev/null || true)"

  if test -n "${entrypoint}"; then
    echo "${entrypoint}"
  elif test -f "${dir}"/flake.nix; then
    echo flake.nix
  elif test -f "${dir}"/default.nix; then
    echo default.nix
  else
    echo "ERROR: No entrypoint found for config '$(realpath "${CONFIG_TOML}")'" >&2
    exit 1
  fi
  ;;
*)
  echo "Config value '${1}' is invalid" >&2
  exit 1
  ;;
esac
