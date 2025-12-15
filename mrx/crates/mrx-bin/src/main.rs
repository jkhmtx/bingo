use std::path::PathBuf;

use mrx_build::build;
use mrx_generate::generate;
use mrx_hook::hook;
use mrx_show::show;
use mrx_utils::Config;

fn main() {
    let config = Config::try_from(PathBuf::from("mrx.toml")).unwrap();

    // match mrx_command().fallback_to_usage().run() {
    //     MrxCommand::Build { cache } => build(config),
    //     MrxCommand::Generate => generate(config).unwrap(),
    //     MrxCommand::Hook => hook(config),
    //     MrxCommand::Show {
    //         watch_files: show_watch_files,
    //     } => match (show_watch_files, false) {
    //         (true, false) => mrx_show::show(config),
    //         _ => todo!(),
    //     },
    //     MrxCommand::Refresh => mrx_refresh::refresh(config),
    // }
}
