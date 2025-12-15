use bpaf::*;

#[derive(Bpaf, Clone, Debug)]
#[bpaf(command("generate"))]
/// Generate the project's barrel Nix file
pub struct Options {}

impl Default for Options {
    fn default() -> Self {
        Self {}
    }
}

pub fn get_options() -> impl Parser<Options> {
    options().fallback(Options::default())
}
