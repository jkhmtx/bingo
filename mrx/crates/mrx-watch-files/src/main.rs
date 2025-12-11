use std::path::PathBuf;

use mrx_utils::Config;
use mrx_watch_files::watch_files;

fn main() {
    let config = Config::try_from(PathBuf::from("mrx.toml")).unwrap();

    watch_files(config);
}
