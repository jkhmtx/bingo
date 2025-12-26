use clap::Parser;
use mrx_utils::{MrxCli, mrx_cli};

/// Print the post-build shell hook
#[mrx_cli]
#[derive(Parser, MrxCli)]
pub struct Options {}
