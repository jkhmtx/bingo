// function find_files() {
// 	git ls-files --others --exclude-standard -- "${@}"
// 	git ls-files -- "${@}"
// }
//
// export CONFIG_TOML="${CONFIG_TOML}"
// export GET_CONFIG_VALUE="${GET_CONFIG_VALUE}"
//
// derivations_lst="$(mktemp)"
//
// {
// 	CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" derivations
// 	CONFIG_TOML="${CONFIG_TOML}" "${GET_CONFIG_VALUE}" ignores | sed 's/^/:!:/'
// } >"${derivations_lst}"
//
// mapfile -t derivations <"${derivations_lst}"
//
// rm "${derivations_lst}"
//
// mapfile -t paths < <(
// 	find_files "${derivations[@]}" | while read -r file; do
// 		if test -f "${file}"; then
// 			echo "${file}"
// 		fi
// 	done | sort | uniq
// )
//
// for path in "${paths[@]}"; do
// 	# Start: ./path/to/scripts/bin/name/main.nix
//
// 	# Start: path/to/scripts/bin/name/main.nix
// 	path="${path//\.\//}"
//
// 	# After: path.to.scripts.bin.name.main.nix
// 	attr_path="${path//\//.}"
//
// 	case "${attr_path}" in
// 	scripts.bin* | scripts.lib* | scripts.util*)
// 		# When there is no sub-project (e.g. 'testbed')
// 		attr_path_prefix=root.
// 		;;
// 	*)
// 		attr_path_prefix=
// 		;;
// 	esac
//
// 	# After: path.to[.lib].name.main.nix
// 	attr_path="${attr_path//scripts\.bin\./}"
// 	attr_path="${attr_path//scripts\.lib\./lib.}"
// 	attr_path="${attr_path//scripts\.util\./util.}"
//
// 	# After: path.to.name
// 	attr_path="${attr_path//\.main\.nix/}"
//
// 	echo "${attr_path_prefix}${attr_path} ${path}"
// done

use ignore::WalkBuilder;

use crate::{Config, PathAttrset};

pub fn find_nix_raw_attrset(config: Config) -> PathAttrset {
    let mut attrset = PathAttrset::new();
    let mut builder = WalkBuilder::new("./");
    builder.filter_entry(|entry| {
        entry.path().is_dir() || entry.file_name().to_string_lossy().ends_with("main.nix")
    });
    if let Some(ignore) = config.get_ignore_file() {
        builder.add_custom_ignore_filename(ignore);
    }

    for result in builder.build() {
        if let Ok(dir_entry) = result {
            let path_buf = dir_entry.path().to_owned();
            if !path_buf.is_dir() {
                let name = path_buf.display().to_string();
                let name = name.replace("./", "");
                let name = name.replace("/", ".");
                let name = name.replace(".main.nix", "");
                let name = name.replace("scripts.bin", "root");
                let name = name.replace("scripts.lib", "root.lib");
                let name = name.replace("scripts.util", "root.util");
                attrset.insert(name, path_buf);
            }
        }
    }

    attrset
}

#[cfg(test)]
mod tests {
    use crate::find_nix_raw_attrset;

    use super::*;

    #[test]
    fn it_works() {
        let config = Config::new();
        let result = find_nix_raw_attrset(config);
        assert_eq!(result, PathAttrset::new());
    }
}
