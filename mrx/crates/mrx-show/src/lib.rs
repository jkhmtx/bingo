mod watch_files;

use mrx_cli::ShowOptions;
use mrx_utils::Config;

pub fn show(config: Config, options: ShowOptions) -> () {
    if options.watch_files {
        crate::watch_files::watch_files(config);
    }

    todo!();
}
