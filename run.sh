#!/usr/bin/env bash

set -euo pipefail

trap 'echo "Error on line $LINENO"; exit 1' ERR
trap 'echo "Exiting"; exit 0' SIGINT SIGTERM

main() {
  export BATCH_NUMBER TEST EXTRACT CROP SINGLE DOUBLE

  # Convert jpg into png
  find . -name "*.jpg" -exec mogrify -format png {} \;

  for part in base cropped singles doubles; do
    mkdir -p batches/"${BATCH_NUMBER}/${part}"
  done

  local extract_env_file="batches/$BATCH_NUMBER/extract.env"
  local crop_env_file="batches/$BATCH_NUMBER/crop.env"
  local single_env_file="batches/$BATCH_NUMBER/single.env"
  local double_env_file="batches/$BATCH_NUMBER/double.env"

  # Extract
  if [ "${EXTRACT}" = 1 ]; then
    if [ ! -s "$extract_env_file" ]; then
      >&2 echo "WARNING: No env file found for extract"
    fi

    # shellcheck disable=1090
    . "$extract_env_file" || true

    ./extract.sh

    # Test
    if [ "${TEST:?}" = 1 ]; then
      viewnior batches/"$BATCH_NUMBER"/base/base-0.png
      exit
    fi
  fi

  # Crop
  if [ "${CROP}" = 1 ]; then
    if [ ! -s "$crop_env_file" ]; then
      >&2 echo "FATAL: No env file found for crop"
      return 1
    fi

    # shellcheck disable=1090
    . "$crop_env_file"

    ./crop.sh

    # Test
    if [ "${TEST:?}" = 1 ]; then
      viewnior batches/"$BATCH_NUMBER"/cropped/base-0.png
      exit
    fi
  fi

  local cropped_files
  cropped_files="$(find batches/"$BATCH_NUMBER"/cropped -maxdepth 1 -name "*.png" | sort -V)"

  # Single
  if [ "${SINGLE:?}" = 1 ]; then
    if [ ! -s "$single_env_file" ]; then
      >&2 echo "FATAL: No env file found for singles batch"
      return 1
    fi

    # shellcheck disable=1090
    . "$single_env_file"

    local single_test=$TEST
    while read -r file; do
      ./overlay.sh single "$file"

      # Test
      if [ "$single_test" = 1 ]; then
        viewnior batches/"$BATCH_NUMBER"/singles/single_-0.png
        single_test=0
        exit
      fi
    done <<<"$cropped_files"
  fi

  # Double
  if [ "${DOUBLE:?}" = 1 ]; then
    if [ ! -s "$double_env_file" ]; then
      >&2 echo "FATAL: No env file found for singles batch"
      return 1
    fi

    # shellcheck disable=1090
    . "$double_env_file"

    local double_test=$TEST

    while read -r first second; do
      ./overlay.sh double "$first" "$second"

      # Test
      if [ "$double_test" = 1 ]; then
        viewnior batches/"$BATCH_NUMBER"/doubles/double_-0--1.png
        double_test=0
        exit
      fi
    done <<<"$(echo "$cropped_files" | xargs -n2)"
  fi
}

echo "${@}"

export BATCH_NUMBER="$1"

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
