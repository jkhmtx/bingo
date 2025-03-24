#!/usr/bin/env bash

set -e -o pipefail

(
	cd batches/"${BATCH_NUMBER:?}"
	# shellcheck disable=2011
	ls base | xargs -I{} magick base/{} -crop "${CROP_SIZE:?}"+"${CROP_OFFSET:?}" cropped/{}
)
