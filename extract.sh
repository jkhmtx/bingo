#!/usr/bin/env bash

set -euo pipefail

log() {
  >&2 echo "${@}"
}

export BATCH_NUMBER="${BATCH_NUMBER}"
export DENSITY="${DENSITY:-300}"
export RESIZE_PERCENTAGE="${RESIZE_PERCENTAGE:-25%}"
echo "pagenum ${PAGE_NUMBER:-}"

batch_dir=batches/"${BATCH_NUMBER}"
mkdir -p "${batch_dir}"/base

function extract() {
  if test -n "${1:-}"; then
    pdf_address="./pdfs/${BATCH_NUMBER}.pdf[${1}]"
    dest="${batch_dir}"/base-"${i}".png
  else
    pdf_address="./pdfs/${BATCH_NUMBER}.pdf"
    dest="${batch_dir}"/base.png
  fi

  magick_args=(
    -monitor
    -limit memory 32
    -limit map 32
    -density "${DENSITY}"
    "${pdf_address}"
    -resize "${RESIZE_PERCENTAGE}"
    "${dest}"
  )

  nice -20 magick "${magick_args[@]}"
}

if test -n "${PAGES:-}"; then
  for i in $(seq 0 "$((PAGES - 1))"); do
    log "Extracting from PDF - ${i}"
    extract "${i}"
  done
else
  log "Extracting from PDF"
  extract
fi

find "${batch_dir}" \
  -type f \
  -name 'base*' \
  -not -path "${batch_dir}"'/base/*' \
  -print0 |
  xargs \
    -0 \
    -I'{}' \
    mv '{}' "${batch_dir}"/base/
