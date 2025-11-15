#!/usr/bin/env bash

set -euo pipefail

export BATCH_NUMBER="${BATCH_NUMBER}"

with_stderr() {
	>&2 "${@}"
}

log() {
	with_stderr echo "LOG: " "${@}"
}

get_template_filename() {
	local filename=''
	local no_path=./bingo/templates/${BATCH_NUMBER}

	if test -n "${TEMPLATE_FILENAME:-}"; then
		filename="$TEMPLATE_FILENAME"
	elif [ -f "$no_path".png ]; then
		filename="$no_path".png
	elif test -f "$no_path".jpg; then
		filename="$no_path".jpg
	fi

	if test -z "${filename}"; then
		log "No $no_path.png or $no_path.jpg found"

		return 1
	fi

	echo "${filename}"
}

multiply() {
	echo "$1 * $2" | bc
}
