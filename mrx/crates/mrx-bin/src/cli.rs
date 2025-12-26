use clap::{Parser, Subcommand};
use mrx_build::Options as BuildOptions;
use mrx_cache::Options as CacheOptions;
use mrx_generate::Options as GenerateOptions;
use mrx_hook::Options as HookOptions;
use mrx_refresh::Options as RefreshOptions;
use mrx_show::Options as ShowOptions;

/// Commands considered "plumbing" which are not generally intended for end users.
#[derive(Subcommand)]
pub enum Plumbing {
    Cache(CacheOptions),
}

#[derive(Subcommand)]
pub enum MrxCommand {
    Build(BuildOptions),
    Generate(GenerateOptions),
    Hook(HookOptions),
    Refresh(RefreshOptions),
    Show(ShowOptions),
    #[command(subcommand)]
    Plumbing(Plumbing),
}

#[derive(Parser)]
#[command(version, about)]
pub struct MrxCli {
    #[command(subcommand)]
    pub command: MrxCommand,
}

impl MrxCli {
    pub fn args() -> Self {
        Self::parse()
    }
}
