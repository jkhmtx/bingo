use std::path::PathBuf;

use mrx_build::build;
use mrx_cache::cache;
use mrx_cli::SubcommandOptions;
use mrx_generate::generate;
use mrx_hook::hook;
use mrx_refresh::refresh;
use mrx_show::show;
use mrx_utils::Config;

fn main() {
    let config = Config::try_from(PathBuf::from("mrx.toml")).unwrap();

    if let Err(e) = handle(config) {
        eprintln!("{}", e.to_string());

        std::process::exit(1);
    }
}

fn handle(config: Config) -> anyhow::Result<()> {
    let subcommand_options = SubcommandOptions::try_from(std::env::args().collect::<Vec<_>>())?;
    match subcommand_options {
        SubcommandOptions::Build(opts) => build(config, opts).map(|paths| {
            for p in paths.into_iter() {
                println!("{}", p);
            }
        })?,
        SubcommandOptions::Cache(opts) => cache(config, opts)?,
        SubcommandOptions::Generate(opts) => generate(config, opts)?,
        SubcommandOptions::Hook(opts) => hook(config, opts),
        SubcommandOptions::Refresh(opts) => refresh(config, opts),
        SubcommandOptions::Show(opts) => show(config, opts),
        _ => unreachable!(),
    };

    Ok(())
}
