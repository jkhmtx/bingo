#!/usr/bin/env bash

set -euo pipefail

export BATCH_NUMBER="${BATCH_NUMBER}"
export CROP_SIZE="${CROP_SIZE}"
export CROP_OFFSET="${CROP_OFFSET}"

(
	cd batches/"${BATCH_NUMBER}"
	# shellcheck disable=2011
	ls base | xargs -I'{}' magick base/'{}' -crop "${CROP_SIZE}"+"${CROP_OFFSET}" cropped/{}
)
