# shellcheck shell=bash

export DESTINATION="${DESTINATION}"
export FIND_GENERATED_NIX_RAW_ATTRSET="${FIND_GENERATED_NIX_RAW_ATTRSET}"

root="$(git rev-parse --show-toplevel)"

dest="$(realpath "${DESTINATION}")"
dest="${dest##"${root}/"}"
num_slashes=$(echo "${dest}" | grep --only-matching '/' | wc -l)

prefix=''
for ((i = 0; i < num_slashes; i++)); do
  prefix="${prefix}../"
done

mkdir -p "$(dirname "${dest}")"

{
  echo '{...}: {'
  "${FIND_GENERATED_NIX_RAW_ATTRSET}" "${@}" |
    while read -r attrname path; do
      echo "  ${attrname} = ${prefix}${path};"
    done
  echo '}'
} >"${dest}"
