mod cli;

use crate::cli::{MrxCli, MrxCommand, Plumbing};
use std::path::PathBuf;

use mrx_build::build;
use mrx_cache::cache;
use mrx_generate::generate;
use mrx_hook::hook;
use mrx_refresh::refresh;
use mrx_show::show;
use mrx_utils::Config;

fn main() {
    let cli = MrxCli::args();
    let config = Config::try_from(PathBuf::from("mrx.toml")).unwrap();

    if let Err(e) = handle(cli, config) {
        eprintln!("{}", e.to_string());

        std::process::exit(1);
    }
}

fn handle(cli: MrxCli, config: Config) -> anyhow::Result<()> {
    match cli.command {
        MrxCommand::Build(opts) => build(config, opts).map(|paths| {
            for p in paths.into_iter() {
                println!("{}", p);
            }
        })?,
        MrxCommand::Plumbing(opts) => match opts {
            Plumbing::Cache(opts) => cache(config, opts)?,
        },
        MrxCommand::Generate(opts) => generate(config, opts)?,
        MrxCommand::Hook(opts) => hook(config, opts),
        MrxCommand::Refresh(opts) => refresh(config, opts),
        MrxCommand::Show(opts) => show(config, opts),
    };

    Ok(())
}
