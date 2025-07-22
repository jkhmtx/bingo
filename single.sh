#!/usr/bin/env bash

export SINGLE="${SINGLE:-0}"
export BATCH_NUMBER="${BATCH_NUMBER}"

if test "${SINGLE}" -ne 1; then
	exit 0
fi

viewnior_first() {
	dir="${1}"
	find batches/"${BATCH_NUMBER}"/"${dir}" -type f | sort -V | head -n1 | xargs viewnior
}

cropped_files="$(find batches/"${BATCH_NUMBER}"/cropped -maxdepth 1 -name "*.png" | sort -V)"
while read -r file; do
	./overlay.sh single "$file"

	# Test
	if test "${TEST:-}" = 1; then
		viewnior_first singles
		exit
	fi
done <<<"$cropped_files"
