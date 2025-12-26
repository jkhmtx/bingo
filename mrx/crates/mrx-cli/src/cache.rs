use bpaf::*;

#[derive(Bpaf, Clone, Debug)]
/// Build and symlink a derivation
/// This is used internally by mrx and is not generally recommended for
/// external users to consume.
#[bpaf(command("cache"))]
pub struct Options {
    /// The derivations to cache
    #[bpaf(positional("DERIVATIONS"))]
    pub derivations: Vec<String>,
}

impl Default for Options {
    fn default() -> Self {
        Self {
            derivations: vec![],
        }
    }
}

pub fn get_options() -> impl Parser<Options> {
    options()
}
