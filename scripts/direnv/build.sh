#!/usr/bin/env bash

set -euo pipefail

export GENERATED_NIX="${GENERATED_NIX}"
export SHELL_HOOK_TEMPLATE="${SHELL_HOOK_TEMPLATE}"

mkdir -p .direnv/shell/bin

nix build '#devShell' --out-link .direnv/shell/result

echo .direnv/shell/result/bin

mapfile -t derivations < <(sed -n 's/  \(.*\) =.*/\1/p' "${GENERATED_NIX}")

for derivation in "${derivations[@]}"; do
	printf "nix run '#%s' -- \${@}\n" "${derivation}" >.direnv/shell/bin/"${derivation}"
	chmod +x .direnv/shell/bin/"${derivation}"
done

{
	echo "${SHELL_HOOK_TEMPLATE}"
	echo "{"
	for derivation in "${derivations[@]}"; do
		echo "echo '  ${derivation}'"
	done
	echo 'echo'
	echo "} >&2"
} >.direnv/hook

chmod +x .direnv/hook

echo ".direnv/shell/bin"
