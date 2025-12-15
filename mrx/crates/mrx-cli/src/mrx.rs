use bpaf::*;

use crate::build::{Options as BuildOptions, get_options as get_build_options};

#[derive(Bpaf, Clone, Debug)]
#[bpaf(options)]
pub struct MrxCommand {
    #[bpaf(external(get_build_options))]
    pub build: BuildOptions,

    #[bpaf(external(crate::generate::get_options))]
    pub generate: crate::generate::Options,

    #[bpaf(external(crate::hook::get_options))]
    pub hook: crate::hook::Options,

    #[bpaf(external(crate::refresh::get_options))]
    pub refresh: crate::refresh::Options,

    #[bpaf(external(crate::show::get_options))]
    pub show: crate::show::Options,
}
