# shellcheck shell=bash

export SHELL_DIR="${SHELL_DIR}"
result="${SHELL_DIR}"/result

nix build '#shell' --out-link "${result}"

echo "${result}"/bin
