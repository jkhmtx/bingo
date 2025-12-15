use bpaf::*;

#[derive(Bpaf, Clone, Debug)]
#[bpaf(command("show"))]
/// Print some aspect of the mrx configuration or build system to stdout
pub struct Options {
    #[bpaf(long("watch-files"))]
    /// Print watch files for another program to consume.
    /// Watch files are those which are nodes in the dependency graph
    /// rooted by the entrypoint.
    pub watch_files: bool,
}

impl Default for Options {
    fn default() -> Self {
        Self { watch_files: true }
    }
}

pub fn get_options() -> impl Parser<Options> {
    options().fallback(Options::default())
}
