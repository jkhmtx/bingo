#!/usr/bin/env bash

set -euo pipefail

export CROP="${CROP:-}"
export BATCH_NUMBER="${BATCH_NUMBER}"
export CROP_SIZE="${CROP_SIZE}"
export CROP_OFFSET="${CROP_OFFSET}"

if test "${CROP}" -ne 1; then
	exit 0
fi

(
	cd ./bingo/batches/"${BATCH_NUMBER}"
	# shellcheck disable=2011
	ls base | xargs -I'{}' magick ./bingo/base/'{}' -crop "${CROP_SIZE}"+"${CROP_OFFSET}" ./bingo/cropped/{}
)

viewnior_first() {
	dir="${1}"
	find ./bingo/batches/"${BATCH_NUMBER}"/"${dir}" -type f | sort -V | head -n1 | xargs viewnior
}

if test "${TEST:-}" = 1; then
	viewnior_first cropped
fi
