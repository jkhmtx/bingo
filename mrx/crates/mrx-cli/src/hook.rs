use bpaf::*;

#[derive(Bpaf, Clone, Debug)]
#[bpaf(command("hook"))]
/// Print the post-build shell hook
pub struct Options {}

impl Default for Options {
    fn default() -> Self {
        Self {}
    }
}

pub fn get_options() -> impl Parser<Options> {
    options().fallback(Options::default())
}
