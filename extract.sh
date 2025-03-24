#!/usr/bin/env bash

set -euo pipefail

export BATCH_NUMBER

mkdir -p batches/"${BATCH_NUMBER}"
magick -density "${DENSITY:-300}" ./pdfs/"$BATCH_NUMBER".pdf -resize "${RESIZE_PERCENTAGE:-25%}" batches/"$BATCH_NUMBER"/base.png

mkdir -p batches/"$BATCH_NUMBER"/base
mv batches/"$BATCH_NUMBER"/base-* batches/"$BATCH_NUMBER"/base/
