use clap::Parser;
use mrx_utils::{MrxCli, mrx_cli};

/// Build the project according to the manifest
#[mrx_cli]
#[derive(Parser, MrxCli, Debug)]
pub struct Options {
    /// After building, cache the build results into an out-of-store directory
    #[arg()]
    pub cache: Option<bool>,
}
