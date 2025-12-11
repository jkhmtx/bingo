use std::path::PathBuf;

use ignore::WalkBuilder;

use crate::{Config, ConfigValueError, PathAttrset};

fn get_config_ignore(config: &Config) -> Option<&PathBuf> {
    config
        .get_ignore_file()
        .map_err(|e| match e {
            ConfigValueError::MissingValue(_) => {
                PathBuf::new().join(config.dir()).join("mrx.ignore.lst")
            }
            ConfigValueError::Io(e) => {
                panic!("{:?}", e);
            }
        })
        .ok()
        .and_then(|path| if path.exists() { Some(path) } else { None })
}

fn get_config_replacements(_config: &Config) -> Vec<(String, String)> {
    [
        ("scripts.bin", "root"),
        ("scripts.lib", "root.lib"),
        ("scripts.util", "util"),
    ]
    .map(|(a, b)| (a.to_string(), b.to_string()))
    .to_vec()
}

fn get_name(path: &PathBuf, replacements: &[(String, String)]) -> String {
    let mut name = path
        .components()
        .skip(1)
        .take_while(|c| c.as_os_str() != "main.nix")
        .map(|c| c.as_os_str().to_string_lossy())
        .collect::<Vec<_>>()
        .join(".");

    for (from, to) in replacements {
        name = name.replace(from, to);
    }

    name
}

pub fn find_nix_path_attrset(config: &Config) -> PathAttrset {
    let mut attrset = PathAttrset::new();

    let mut builder = WalkBuilder::new(config.dir());
    builder.filter_entry(|entry| {
        entry.path().is_dir() || entry.file_name().to_string_lossy() == "main.nix"
    });

    if let Some(ignore) = get_config_ignore(&config) {
        builder.add_custom_ignore_filename(ignore);
    }

    let paths = builder.build().filter_map(|r| {
        r.ok().and_then(|d| {
            let dir = d.path();
            if dir.is_dir() {
                None
            } else {
                Some(dir.to_owned())
            }
        })
    });

    let replacements = get_config_replacements(&config);

    for path in paths {
        let name = get_name(&path, &replacements);

        attrset.insert(name, path);
    }

    attrset
}
