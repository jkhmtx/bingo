use mrx_cli::HookOptions;
use mrx_utils::{Config, find_bin_attrnames};

pub fn hook(config: Config, options: HookOptions) {
    let bins = {
        let mut bins = find_bin_attrnames(&config);

        bins.sort();
        bins
    };

    println!("The following commands are available in your shell:");
    for bin in bins {
        println!("  {}", bin);
    }
}
