# shellcheck shell=bash

export GENERATED_NIX="${GENERATED_NIX}"

mapfile -t direnv_files < <(git ls-files ':direnv/*')

{
	echo flake.lock

	for file in "${direnv_files[@]}"; do
		echo "${file#./}"
	done

	while read -r parent child; do
		if test -n "${child}"; then
			echo "${child}"
		else
			echo "${parent}"
		fi
	done | grep -v "${GENERATED_NIX}"
} | sort | uniq
