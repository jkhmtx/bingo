mod watch_files;

mod cli;
pub use cli::Options;
use cli::Target;
use mrx_utils::Config;

pub fn show(config: Config, options: Options) -> () {
    match options.target {
        Target::WatchFiles => crate::watch_files::watch_files(config),
    }
}
