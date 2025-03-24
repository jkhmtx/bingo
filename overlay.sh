#!/usr/bin/env bash

set -euo pipefail

export BATCH_NUMBER

get_template_filename() {

	if [ -n "${TEMPLATE_FILENAME:-}" ]; then
		echo "$TEMPLATE_FILENAME"
		return
	fi

	local basename=./templates/${BATCH_NUMBER}

	if [ -f "$basename".png ]; then
		echo "$basename".png

		return
	fi

	if [ -f "$basename".jpg ]; then
		echo "$basename".jpg

		return
	fi

	>&2 echo "INVALID TEMPLATE FILENAME"

	return 1
}

log() {
	echo "LOG: $1" >&2
}

multiply() {
	echo "$1 * $2" | bc
}

overlay_single() {
	local template_filename
	template_filename="$(get_template_filename)"

	local tmpdir
	tmpdir=$(mktemp -d)

	local output_dir="${OUTPUT_DIR:-./batches/${BATCH_NUMBER:?}/singles}"

	mkdir -p "$output_dir"

	local first_image=$1

	local first_short
	first_short=$(short "$1")

	local output_filename="single_$first_short.png"
	local dest="$output_dir/$output_filename"

	local original_image_size_width original_image_size_height
	original_image_size_width=$(magick identify -format "%w" "$first_image")
	original_image_size_height=$(magick identify -format "%h" "$first_image")

	local image_scale="${IMAGE_SCALE:-1.0}"

	local image_resize="${IMAGE_RESIZE:-"$(multiply "$original_image_size_width" "$image_scale")"x"$(multiply "$original_image_size_height" "$image_scale")"}"
	local first_image_offset="${IMAGE_OFFSET_1:--215-375}"

	log "Using image_resize=$image_resize first_image_offset=$first_image_offset second_image_offset=${second_image_offset:-}"

	echo "template_filename=$template_filename" "first_image=$first_image" "image_resize=$image_resize" "first_image_offset=$first_image_offset" "dest=$dest"

	magick "$template_filename" "$first_image" \
		-gravity Center \
		-geometry "$image_resize$first_image_offset" \
		-composite \
		"$dest"

}

short() {
	local filename
	filename="$(basename -s .png "$1")"

	echo "${filename: -2}"
}

overlay_double() {
	local template_filename
	template_filename="$(get_template_filename)"

	local tmpdir
	tmpdir=$(mktemp -d)

	local output_dir="${OUTPUT_DIR:-./batches/${BATCH_NUMBER:?}/doubles}"

	mkdir -p "$output_dir"

	local first_image=$1
	local second_image=$2
	log "Group: $first_image $second_image"

	local first_short
	first_short=$(short "$1")
	second_short=$(short "$2")

	local output_filename="double_$first_short-$second_short.png"
	local dest="$output_dir/$output_filename"

	local original_image_size_width original_image_size_height
	original_image_size_width=$(magick identify -format "%w" "$first_image")
	original_image_size_height=$(magick identify -format "%h" "$first_image")

	local image_scale="${IMAGE_SCALE:-1.0}"

	local image_resize="${IMAGE_RESIZE:-"$(multiply "$original_image_size_width" "$image_scale")"x"$(multiply "$original_image_size_height" "$image_scale")"}"
	local first_image_offset="${IMAGE_OFFSET_1:--215-375}"
	local second_image_offset="${IMAGE_OFFSET_2:-+220+495}"

	local tmp_dest="$tmpdir/$output_filename"

	magick "$template_filename" "$first_image" \
		-gravity Center \
		-geometry "$image_resize$first_image_offset" \
		-composite \
		"$tmp_dest"

	magick "$tmp_dest" "$second_image" \
		-gravity Center \
		-geometry "$image_resize$second_image_offset" \
		-composite \
		"$dest"

	echo "$dest"
}

main() {
	case "$1" in
	single)
		shift
		overlay_single "$@"
		;;
	double)
		shift
		overlay_double "$@"
		;;
	*)
		>&2 echo "Must use single or double as first arg"

		return 1
		;;
	esac
}

main "$@"
