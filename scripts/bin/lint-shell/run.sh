# shellcheck shell=bash

root="$(git rev-parse --show-toplevel)"

cd "${root}" || exit 1

mapfile -d '' -t files < <(
	git ls-files --exclude-standard --others -z '*.sh' && git ls-files --exclude-standard -z '*.sh'
)

if test -v CI; then
	shellcheck "${files[@]}"
else
	if ! shellcheck --format diff "${files[@]}" | patch -p1; then
		shellcheck "${files[@]}"
	fi
fi
