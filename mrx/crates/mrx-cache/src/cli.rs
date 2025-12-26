use clap::Parser;
use mrx_utils::{MrxCli, mrx_cli};

/// Build and symlink derivations
#[mrx_cli]
#[derive(Parser, MrxCli)]
pub struct Options {
    /// The derivations to cache
    pub derivations: Vec<String>,
}
