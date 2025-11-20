#!/usr/bin/env bash

export DOUBLE="${DOUBLE:-0}"
export BATCH_NUMBER="${BATCH_NUMBER}"

if test "${DOUBLE}" -ne 1; then
	exit 0
fi

viewnior_first() {
	dir="${1}"
	find ./bingo/batches/"${BATCH_NUMBER}"/"${dir}" -type f | sort -V | head -n1 | xargs viewnior
}

cropped_files="$(find ./bingo/batches/"${BATCH_NUMBER}"/cropped -maxdepth 1 -name "*.png" | sort -V)"
while read -r first second; do
	./bingo/run/overlay.sh double "$first" "$second"

	# Test
	if test "${TEST:-}" = 1; then
		viewnior_first doubles
		exit
	fi
done <<<"$(echo "$cropped_files" | xargs -n2)"
