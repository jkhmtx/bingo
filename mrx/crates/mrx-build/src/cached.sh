# shellcheck shell=bash

export CACHE_DIR="${CACHE_DIR}"
export DERIVATION="${DERIVATION}"
export THIS_MRX_BIN="${THIS_MRX_BIN}"

cached_bin="${CACHE_DIR}"/"${DERIVATION}"

# If 'mrx' is not in the PATH, substitute it with the one
# that writes this script file
mrx_bin=
if type -p mrx >/dev/null 2>&1; then
  mrx_bin=mrx
else
  mrx_bin="${THIS_MRX_BIN}"
fi

if ! bash -n "${cached_bin}" >/dev/null >&2; then
  "${mrx_bin}" cache "${DERIVATION}"
fi

${cached_bin} "${@}"
