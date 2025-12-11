use mrx_utils::{Config, find_nix_path_attrset};

fn find_bins(config: Config) -> Vec<String> {
    let mut bins = find_nix_path_attrset(&config)
        .iter()
        .filter(|(_, buf)| buf.components().any(|c| c.as_os_str() == "bin"))
        .map(|(attrname, _)| attrname)
        .cloned()
        .collect::<Vec<_>>();

    bins.sort();

    bins
}

pub fn hook(config: Config) {
    let bins = find_bins(config);

    println!("The following commands are available in your shell:");
    for bin in bins {
        println!("  {}", bin);
    }
}
