use std::path::PathBuf;

use mrx_hook::hook;
use mrx_utils::Config;
use mrx_watch_files::watch_files;

use crate::command::{MrxCommand, mrx_command};

mod command;

fn main() {
    let config = Config::try_from(PathBuf::from("mrx.toml")).unwrap();

    match mrx_command().fallback_to_usage().run() {
        MrxCommand::Hook => hook(config),
        MrxCommand::Show {
            watch_files: show_watch_files,
        } => match (show_watch_files, false) {
            (true, false) => watch_files(config),
            _ => todo!(),
        },
    }
}
