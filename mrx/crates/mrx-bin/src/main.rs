use std::path::PathBuf;

use mrx_build::build;
use mrx_cli::{options, run_and_show_usage};
use mrx_generate::generate;
use mrx_hook::hook;
use mrx_refresh::refresh;
use mrx_show::show;
use mrx_utils::Config;

fn main() {
    let config = Config::try_from(PathBuf::from("mrx.toml")).unwrap();

    let args = options().run();

    let first_arg = std::env::args().nth(1).unwrap_or_else(|| {
        println!("{}", run_and_show_usage());

        std::process::exit(1);
    });

    match first_arg.as_str() {
        "build" => build(config, args.build)
            .expect("Build command failed")
            .into_iter()
            .for_each(|p| println!("{}", p)),
        "generate" => generate(config, args.generate).expect("Generate command failed"),
        "hook" => hook(config, args.hook),
        "show" => show(config, args.show),
        "refresh" => refresh(config, args.refresh),
        _ => unreachable!(),
    }
}
