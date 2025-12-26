use clap::Parser;

/// Build and symlink derivations
#[derive(Parser)]
pub struct Options {
    /// The derivations to cache
    pub derivations: Vec<String>,
}
