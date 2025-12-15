use bpaf::*;

#[derive(Bpaf, Clone, Debug)]
#[bpaf(command("refresh"))]
/// Refresh the build cache if it exists
pub struct Options {}

impl Default for Options {
    fn default() -> Self {
        Self {}
    }
}

pub fn get_options() -> impl Parser<Options> {
    options().fallback(Options::default())
}
