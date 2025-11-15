#!/usr/bin/env bash

set -euo pipefail

export GENERATED_NIX="${GENERATED_NIX}"

find . -type f -path "*/scripts/bin/*"
find . -type f -path "./scripts/direnv/*"
find . -type f -name "*.nix" -not -wholename "./${GENERATED_NIX}"
