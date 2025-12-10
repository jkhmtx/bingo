use mrx_utils::{Config, find_nix_raw_attrset};

fn find_bins(config: Config) -> Vec<String> {
    find_nix_raw_attrset(config)
        .iter()
        .filter(|(_, buf)| buf.components().any(|c| c.as_os_str() == "bin"))
        .map(|(attrname, _)| attrname)
        .cloned()
        .collect()
}

pub fn hook(config: Config) {
    let bins = find_bins(config);

    println!("The following commands are available in your shell:");
    for bin in bins {
        println!("  {}", bin);
    }
}
