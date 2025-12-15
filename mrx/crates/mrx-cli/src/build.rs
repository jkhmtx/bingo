use bpaf::*;

#[derive(Bpaf, Clone, Debug)]
/// Build the project according to the manifest
#[bpaf(command("build"))]
pub struct Options {
    #[bpaf(long("cache"))]
    /// After building, cache the build results into an out-of-store directory
    pub cache: Option<bool>,
}

impl Default for Options {
    fn default() -> Self {
        Self { cache: Some(true) }
    }
}

pub fn get_options() -> impl Parser<Options> {
    options().fallback(Options::default())
}
