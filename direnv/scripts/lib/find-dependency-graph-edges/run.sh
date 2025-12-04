# shellcheck shell=bash

export FIND_GENERATED_NIX_RAW_ATTRSET="${FIND_GENERATED_NIX_RAW_ATTRSET}"

root="$(git rev-parse --show-toplevel)"

files=("$(realpath ./flake.nix)")

declare -A scanned
declare -A attrs

raw_attrs="$("${FIND_GENERATED_NIX_RAW_ATTRSET}" "${@}")"

while read -r attrname path; do
	attrs["${attrname}"]="${path}"
done <<<"${raw_attrs}"

for attrname in "${!attrs[@]}"; do
	# shellcheck disable=2028
	echo "\.${attrname}\b([^-]|$)"
done >.direnv/patterns.lst

{
	echo flake.nix flake.lock

	# Find all paths referenced by flake.nix, or its dependents.
	while test "${#files[@]}" -gt 0; do
		for file in "${files[@]}"; do
			file="${file##"${root}/"}"
			if ! test -n "${scanned["${file}"]:-}" && test "${file}" != "${file%.nix}"; then
				echo "${file}" flake.lock
				# TODO: Add interpolated paths detection so that the if block internal is reachable
				if false; then
					{
						echo "WARNING"
						echo "Paths that contain interpolation are not automatically added to watched files."
						echo "To silence this warning, add the file to '.envrc.watch.ignores.lst'."
						echo "${file}"
					} >&2
				fi

				mapfile -t path_matches < <(grep \
					--extended-regexp \
					--only-matching \
					'(\.|(\.\.|\.)/[a-zA-Z0-9\./_\+\-]+)[ ;]' \
					"${file}")

				pushd "$(dirname "${file}")" >/dev/null 2>&1 || exit 1

				for match in "${path_matches[@]}"; do
					match="${match/ /}"
					match="${match/;/}"
					match="$(realpath "${match}")"
					match="${match##"${root}/"}"

					echo "${file} ${match}"

					files+=("${match}")
				done
				popd >/dev/null 2>&1 || exit 1

				mapfile -t drv_matches < <(grep --extended-regexp --only-matching --file .direnv/patterns.lst "${file}" | sed 's/\.\(.*\w\).*/\1/' || true)

				for attrname in "${drv_matches[@]}"; do
					echo "${file}" "${attrs["${attrname}"]}"
				done

				# while read -r attrname path; do
				# 	if ! grep -q -E "(^|[^-])\b${attrname}\b([^-]|$)" "${file}"; then
				# 		continue
				# 	fi
				#
				# 	match="$(realpath "${path}")"
				# 	match="${match##"${root}/"}"
				# 	if test "${match}" = "${file}"; then
				# 		continue
				# 	fi
				#
				# 	echo "${file} ${match}"
				#
				# 	files+=("${match}")
				# done <<<"${attrs[*]}"
			fi

			path_matches=()

			# scanned["${file}"]='done'
			files=("${files[@]:1}")
		done
	done
} | sort | uniq
