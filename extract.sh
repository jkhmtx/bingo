#!/usr/bin/env bash

set -euo pipefail

log() {
  >&2 echo "${@}"
}

export BATCH_NUMBER

log "Extracting from PDFs"
mkdir -p batches/"${BATCH_NUMBER}"
nice -20 magick -monitor -limit memory 32 -limit map 32 -density "${DENSITY:-300}" ./pdfs/"$BATCH_NUMBER".pdf -resize "${RESIZE_PERCENTAGE:-25%}" batches/"$BATCH_NUMBER"/base.png

mkdir -p batches/"$BATCH_NUMBER"/base
mv batches/"$BATCH_NUMBER"/base-* batches/"$BATCH_NUMBER"/base/
