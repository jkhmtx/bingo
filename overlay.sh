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
	local no_path=./templates/${BATCH_NUMBER}

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

overlay() {
	export OFFSET="${OFFSET}"
	export SCALE="${SCALE}"

	local template_filename="${1}"
	local image="${2}"

	local original_image_size_width original_image_size_height
	original_image_size_width=$(magick identify -format "%w" "$image")
	original_image_size_height=$(magick identify -format "%h" "$image")

	local resize
	resize="$(multiply "$original_image_size_width" "${SCALE}")"x"$(multiply "$original_image_size_height" "${SCALE}")"

	log "Using image_resize=$resize offset=${OFFSET}"

	magick "$template_filename" "$image" \
		-gravity Center \
		-geometry "${resize}${OFFSET}" \
		-composite \
		-
}

get_id() {
	local _basename
	_basename="$(basename "${1}")"

	local no_prefix="${_basename##*-}"
	local no_suffix_or_prefix="${no_prefix%%.*}"

	echo "${no_suffix_or_prefix}"
}

main() {
	case "$1" in
	single)
		shift

		export IMAGE_OFFSET="${IMAGE_OFFSET_1}"
		export IMAGE_SCALE="${IMAGE_SCALE}"

		local template_filename
		template_filename="$(get_template_filename)"

		local output_filename
		output_filename="single_$(get_id "${1}").png"
		local dest=./batches/"${BATCH_NUMBER}/singles/$output_filename"

		SCALE="${IMAGE_SCALE}" \
			OFFSET="${IMAGE_OFFSET}" \
			overlay "${template_filename}" "${1}" >"${dest}"

		echo "${dest}"
		;;
	double)
		shift

		export IMAGE_OFFSET_1="${IMAGE_OFFSET_1}"
		export IMAGE_OFFSET_2="${IMAGE_OFFSET_2}"
		export IMAGE_SCALE="${IMAGE_SCALE}"

		local template_filename
		template_filename="$(get_template_filename)"

		local tmp
		tmp="$(mktemp)"

		SCALE="${IMAGE_SCALE}" \
			OFFSET="${IMAGE_OFFSET_1}" \
			overlay "${template_filename}" "${1}" >"${tmp}"

		local output_filename
		output_filename="double_$(get_id "${1}")-$(get_id "${2}").png"
		local dest=./batches/"${BATCH_NUMBER}/doubles/$output_filename"

		SCALE="${IMAGE_SCALE}" \
			OFFSET="${IMAGE_OFFSET_2}" \
			overlay "${tmp}" "${2}" >"${dest}"

		rm "${tmp}"

		echo "${dest}"
		;;
	*)
		log "Must use single or double as first arg"

		return 1
		;;
	esac
}

main "$@"
