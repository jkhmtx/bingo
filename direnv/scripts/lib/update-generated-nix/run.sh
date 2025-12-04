# shellcheck shell=bash

export FIND_GENERATED_NIX_RAW_ATTRSET="${FIND_GENERATED_NIX_RAW_ATTRSET}"
export PATH_PREFIX="${PATH_PREFIX}"

echo '{...}: {'
"${FIND_GENERATED_NIX_RAW_ATTRSET}" |
	while read -r attrname path; do
		echo "  ${attrname} = ${PATH_PREFIX}${path};"
	done
echo '}'
