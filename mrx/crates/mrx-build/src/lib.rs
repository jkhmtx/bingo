use mrx_cli::BuildOptions;
use mrx_utils::{Config, find_nix_path_attrset};

use std::fmt::Write as _;
use std::io::Write as __;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum BuildError {
    #[error("invalid destination `{0}`")]
    InvalidDestination(String),
    #[error("Could not create file")]
    IoError(#[from] std::io::Error),
    #[error("Error constructing file string")]
    FmtError(#[from] std::fmt::Error),
}

type BuildResult<T> = Result<T, BuildError>;

pub fn build(config: Config, options: BuildOptions) -> BuildResult<()> {
    Ok(())
}
