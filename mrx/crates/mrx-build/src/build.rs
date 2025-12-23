use mrx_cli::BuildOptions;
use mrx_utils::fs::recreate_dir;
use mrx_utils::{Config, find_bin_attrnames};

use std::fmt::Write as _;
use std::io::Write as __;
use std::os::unix::fs::PermissionsExt as UnixPermissions;
use std::panic;
use std::path::{Path, PathBuf};
use thiserror::Error;

use crate::nix_build_output::NixBuildStructuredStdout;

#[derive(Debug, Error)]
pub enum BuildError {
    #[error("Missing either an 'installables' list in the config or a 'default.nix' in the root.")]
    NoInstallables,
    #[error("Failed to write to stdin")]
    Stdin,
    #[error("The build command failed to run")]
    Run(#[from] std::io::Error),
    #[error("{0}")]
    Failed(String),
    #[error("TODO: Implement")]
    Todo,
}

type BuildResult<T> = Result<T, BuildError>;

fn reset_bin_dir(bin_dir: &Path) -> BuildResult<()> {
    recreate_dir(&bin_dir).map_err(|_| BuildError::Todo)
}

fn write_bin_dir(bin_dir: &Path, config: &Config) -> BuildResult<()> {
    let cache_dir = {
        let dir = config.dir();

        dir.join("cache")
    };

    let bins = find_bin_attrnames(config);
    let cached_sh = include_str!("./cached.sh");

    for bin in bins {
        let path = bin_dir.join(&bin);

        let buf = {
            let mut buf = String::new();

            let this_mrx_bin = std::env::current_exe().map_err(|_| BuildError::Todo)?;

            let env_vars = [
                ("THIS_MRX_BIN", this_mrx_bin.to_string_lossy()),
                ("DERIVATION", bin.into()),
                ("CACHE_DIR", cache_dir.to_string_lossy()),
            ];

            for (k, v) in env_vars.into_iter() {
                write!(&mut buf, "export {k}={v}\n").map_err(|_| BuildError::Todo)?;
            }

            write!(&mut buf, "\n{cached_sh}").map_err(|_| BuildError::Todo)?;

            buf
        };

        std::fs::write(&path, buf.as_bytes())?;

        let mut perms = std::fs::metadata(&path)?.permissions();
        perms.set_mode(0o755);
        std::fs::set_permissions(&path, perms)?
    }

    Ok(())
}

pub fn build(config: Config, options: BuildOptions) -> BuildResult<Vec<String>> {
    let installables = config.get_installables();
    let default_nix = std::fs::canonicalize(PathBuf::from("./default.nix")).ok();
    if installables.is_empty() || default_nix.is_none() {
        return Err(BuildError::NoInstallables);
    }

    let args = {
        let mut args = Vec::from(["build", "--json", "--no-link"]);

        if installables.is_empty() {
            args.push("--file");
            args.push(".");
        }

        args
    };

    let build_cmd = {
        let mut build_cmd = std::process::Command::new("nix")
            .args(args)
            .stdin(std::process::Stdio::piped())
            .spawn()?;

        if !installables.is_empty() {
            let mut stdin = build_cmd.stdin.take().ok_or(BuildError::Stdin)?;

            let input_string = installables.to_vec().join("\n");
            if let Err(e) = std::thread::spawn(move || {
                stdin
                    .write_all(input_string.as_bytes())
                    .map_err(|_| BuildError::Stdin)
            })
            .join()
            {
                panic::resume_unwind(e);
            }
        }

        build_cmd
    };

    let output = build_cmd.wait_with_output()?;
    if !output.status.success() {
        let err_out = String::from_utf8_lossy(&output.stderr);

        return Err(BuildError::Failed(err_out.to_string()));
    }

    let bin_dir = if options.cache.unwrap_or(true) {
        let dir = config.dir();

        Some(dir.join("bin"))
    } else {
        None
    };

    let mut paths = NixBuildStructuredStdout::try_from(&output.stdout)
        .map_err(|_| BuildError::Todo)?
        .into_path_strs()
        .ok_or(BuildError::Todo)?;

    if let Some(bin_dir) = bin_dir {
        reset_bin_dir(&bin_dir)?;
        write_bin_dir(&bin_dir, &config)?;

        // If sourced by PATH_add in order,
        // any derivation in a symlinkJoin, built via '${INSTALLABLES}',
        // will be in preferential order in PATH, and shadow the cache-aside
        // implementation in [`bin_dir`].
        // This enables opting out of caching on a per-exe basis.
        paths.insert(0, bin_dir.to_string_lossy().to_string());
    }

    Ok(paths)
}
