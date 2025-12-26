use clap::{Parser, ValueEnum};
use mrx_utils::{MrxCli, mrx_cli};

#[derive(ValueEnum, Clone)]
pub enum Target {
    /// Watch files are nodes in the dependency graph.
    /// These files may be consumed by another program, such as 'direnv' or 'entr', to signal that "on files changed" work needs to be done.
    WatchFiles,
}

/// Print some aspect of the mrx configuration or build system to stdout
#[mrx_cli]
#[derive(Parser, MrxCli)]
pub struct Options {
    /// What to show
    #[arg(value_enum)]
    pub target: Target,
}
