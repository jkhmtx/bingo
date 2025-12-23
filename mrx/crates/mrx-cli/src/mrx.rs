use bpaf::*;

use crate::{BuildOptions, GenerateOptions, HookOptions, RefreshOptions, ShowOptions};

use crate::build::get_options as build;
use crate::generate::get_options as generate;
use crate::hook::get_options as hook;
use crate::refresh::get_options as refresh;
use crate::show::get_options as show;

#[derive(Bpaf, Clone, Debug)]
#[bpaf(options)]
pub struct Options {
    #[bpaf(external(build))]
    pub build: BuildOptions,

    #[bpaf(external(generate))]
    pub generate: GenerateOptions,

    #[bpaf(external(hook))]
    pub hook: HookOptions,

    #[bpaf(external(refresh))]
    pub refresh: RefreshOptions,

    #[bpaf(external(show))]
    pub show: ShowOptions,
}

pub fn run_and_show_usage() -> String {
    options()
        .run_inner(bpaf::Args::from(&["--help"]))
        .unwrap_err()
        .unwrap_stdout()
}
