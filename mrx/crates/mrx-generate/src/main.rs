use std::path::PathBuf;

use mrx_generate::generate;
use mrx_utils::Config;

fn main() {
    let config = Config::try_from(PathBuf::from("mrx.toml")).unwrap();

    generate(config).unwrap();
}
