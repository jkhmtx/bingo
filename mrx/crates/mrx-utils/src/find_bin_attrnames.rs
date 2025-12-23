use crate::{Config, find_nix_path_attrset};

pub fn find_bin_attrnames(config: &Config) -> Vec<String> {
    find_nix_path_attrset(config)
        .iter()
        .filter(|(_, buf)| buf.components().any(|c| c.as_os_str() == "bin"))
        .map(|(attrname, _)| attrname)
        .cloned()
        .collect::<Vec<_>>()
}
