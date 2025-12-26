use clap::Parser;

/// Build the project according to the manifest
#[derive(Parser)]
pub struct Options {
    /// After building, cache the build results into an out-of-store directory
    #[arg()]
    pub cache: Option<bool>,
}
