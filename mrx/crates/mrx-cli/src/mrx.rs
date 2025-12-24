use std::error::Error;
use std::fmt::Display;

use bpaf::*;

use crate::{
    BuildOptions, CacheOptions, GenerateOptions, HookOptions, RefreshOptions, ShowOptions,
};

use crate::build::get_options as build;
use crate::cache::get_options as cache;
use crate::generate::get_options as generate;
use crate::hook::get_options as hook;
use crate::refresh::get_options as refresh;
use crate::show::get_options as show;

#[derive(Bpaf, Clone, Debug, Default)]
#[bpaf(options)]
pub struct Options {
    #[bpaf(external(build))]
    pub build: BuildOptions,

    #[bpaf(external(cache))]
    pub cache: CacheOptions,

    #[bpaf(external(generate))]
    pub generate: GenerateOptions,

    #[bpaf(external(hook))]
    pub hook: HookOptions,

    #[bpaf(external(refresh))]
    pub refresh: RefreshOptions,

    #[bpaf(external(show))]
    pub show: ShowOptions,
}

#[derive(Debug)]
pub enum SubcommandOptions {
    Build(BuildOptions),
    Cache(CacheOptions),
    Generate(GenerateOptions),
    Hook(HookOptions),
    Refresh(RefreshOptions),
    Show(ShowOptions),
}

#[derive(Debug)]
pub enum SubcommandError {
    None,
    Unrecognized,
    Parse(String),
}

impl Display for SubcommandError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let message = match self {
            SubcommandError::None | SubcommandError::Unrecognized => &get_usage_of(options()),
            SubcommandError::Parse(help_str) => help_str,
        };

        f.write_str(message)
    }
}

impl Error for SubcommandError {}

impl From<String> for SubcommandError {
    fn from(value: String) -> Self {
        Self::Parse(value)
    }
}

fn map_options<T: std::fmt::Debug + 'static>(
    parser: impl Parser<T> + 'static,
    args: &[String],
) -> Result<T, String> {
    let options = parser.to_options();
    options
        .run_inner(bpaf::Args::from(args))
        .map_err(|_| get_usage_of(options))
}

impl TryFrom<Vec<String>> for SubcommandOptions {
    type Error = SubcommandError;

    fn try_from(args: Vec<String>) -> Result<Self, Self::Error> {
        let mut args_iter = args.into_iter();

        // burn argv0
        args_iter.next();

        let first = args_iter.next().ok_or_else(|| SubcommandError::None)?;
        let mut rest: Vec<String> = args_iter.collect();

        match first.as_str() {
            "build" => Ok(map_options(build(), rest.as_slice()).map(SubcommandOptions::Build)?),
            "cache" => Ok(map_options(cache(), {
                rest.insert(0, "cache".to_string());
                rest.as_slice()
            })
            .map(SubcommandOptions::Cache)?),
            "generate" => {
                Ok(map_options(generate(), rest.as_slice()).map(SubcommandOptions::Generate)?)
            }
            "hook" => Ok(map_options(hook(), rest.as_slice()).map(SubcommandOptions::Hook)?),
            "refresh" => {
                Ok(map_options(refresh(), rest.as_slice()).map(SubcommandOptions::Refresh)?)
            }
            "show" => Ok(map_options(show(), rest.as_slice()).map(SubcommandOptions::Show)?),
            _ => Err(SubcommandError::Unrecognized),
        }
    }
}

pub fn get_usage_of<T: std::fmt::Debug>(opts: OptionParser<T>) -> String {
    opts.run_inner(bpaf::Args::from(&["--help"]))
        .unwrap_err()
        .unwrap_stdout()
}
