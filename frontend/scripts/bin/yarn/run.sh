# shellcheck shell=bash

root="$(git rev-parse --show-toplevel)"

cd "${root}/frontend" || exit 1

yarn "${@}"
