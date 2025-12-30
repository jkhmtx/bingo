# shellcheck shell=bash

export CLOUDFLARE_ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID}"
export CLOUDFLARE_API_TOKEN="${CLOUDFLARE_API_TOKEN}"
export DIST="${DIST}"

root="$(git rev-parse --show-toplevel)"

cd "${root}/frontend" || exit 1

yarn tsc --build
yarn vite build

CLOUDFLARE_ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID}" \
  CLOUDFLARE_API_TOKEN="${CLOUDFLARE_API_TOKEN}" \
  wrangler pages deploy "${DIST}" --project-name=bingo
