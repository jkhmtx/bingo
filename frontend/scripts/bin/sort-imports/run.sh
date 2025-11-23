# shellcheck shell=bash

root="$(git rev-parse --show-toplevel)"

cd "${root}" || exit 1

mapfile -t files < <(git ls-files ':*.ts' ':*.tsx')

for file in "${files[@]}"; do
  echo "${file}"
  {
    set +e
    grep 'import' "${file}" | sort
    grep -v 'import' "${file}"
    set -e
  } | sponge "${file}"
done
