use std::path::PathBuf;

use mrx_hook::hook;
use mrx_utils::Config;

fn main() {
    let config = Config::try_from(PathBuf::from("mrx.toml")).unwrap();

    hook(config);
}
