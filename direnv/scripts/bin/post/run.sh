# shellcheck shell=bash

export FIND_BINS="${FIND_BINS}"

function indent() {
  cat - | sed 's/^/  /'
}

echo
echo "The following commands are available in your shell:"
echo
"${FIND_BINS}" ':*main.nix' | indent
echo
