#!/usr/bin/env bash

set -euo pipefail

trap 'echo "Error on line $LINENO"; exit 1' ERR
trap 'echo "Exiting"; exit 0' SIGINT SIGTERM

main() {
  export BATCH_NUMBER TEST EXTRACT CROP SINGLE DOUBLE

  # Convert jpg into png
  find . -name "*.jpg" -exec mogrify -format png {} \;

  # Define all necessary dirs
  for part in base cropped singles doubles; do
    mkdir -p batches/"${BATCH_NUMBER}/${part}"
  done

  for mode in extract crop single double; do
    # shellcheck disable=1090
    source "batches/$BATCH_NUMBER/${mode}.env" || exit 1

    ./"${mode}".sh
  done
}

echo "${@}"

export BATCH_NUMBER="${1?Specify batch number, or 'test'}"

case "${2:-}" in
extract)
  export EXTRACT=1
  ;;
crop)
  export CROP=1
  ;;
single)
  export SINGLE=1
  ;;
double)
  export DOUBLE=1
  ;;
all)
  export EXTRACT=${EXTRACT:-1}
  export CROP=${CROP:-1}
  export SINGLE=${SINGLE:-1}
  export DOUBLE=${DOUBLE:-1}
  ;;
'')
  if test "${1}" = test; then
    . ./test.env
  else
    echo "Specify a mode as arg 2: extract, crop, single, double, all"
    exit 1
  fi
  ;;
esac

export TEST=${TEST:-0}
export EXTRACT=${EXTRACT:-0}
export CROP=${CROP:-0}
export SINGLE=${SINGLE:-0}
export DOUBLE=${DOUBLE:-0}

echo "BATCH_NUMBER=$BATCH_NUMBER"
echo "MODES: TEST=$TEST EXTRACT=$EXTRACT CROP=$CROP SINGLE=$SINGLE DOUBLE=$DOUBLE"

main
