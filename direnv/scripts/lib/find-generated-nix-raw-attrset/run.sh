# shellcheck shell=bash

mapfile -t paths < <(
	git ls-files --others --exclude-standard -- "${@}" &&
		git ls-files -- "${@}"
)

for path in "${paths[@]}"; do
	# Start: ./path/to/scripts/bin/name/main.nix

	# Start: path/to/scripts/bin/name/main.nix
	path="${path//\.\//}"

	# After: path.to.scripts.bin.name.main.nix
	attr_path="${path//\//.}"

	case "${attr_path}" in
	scripts.bin* | scripts.lib* | scripts.util*)
		# When there is no sub-project (e.g. 'testbed')
		attr_path_prefix=root.
		;;
	*)
		attr_path_prefix=
		;;
	esac

	# After: path.to[.lib].name.main.nix
	attr_path="${attr_path//scripts\.bin\./}"
	attr_path="${attr_path//scripts\.lib\./lib.}"
	attr_path="${attr_path//scripts\.util\./util.}"

	# After: path.to.name
	attr_path="${attr_path//\.main\.nix/}"

	echo "${attr_path_prefix}${attr_path} ${path}"
done
