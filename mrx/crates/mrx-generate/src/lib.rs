use mrx_cli::GenerateOptions;
use mrx_utils::{Config, find_nix_path_attrset};

use std::fmt::Write as _;
use std::io::Write as __;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum GenerateError {
    #[error("invalid destination `{0}`")]
    InvalidDestination(String),
    #[error("Could not create file")]
    IoError(#[from] std::io::Error),
    #[error("Error constructing file string")]
    FmtError(#[from] std::fmt::Error),
}

type GenerateResult<T> = Result<T, GenerateError>;

pub fn generate(config: Config, _options: GenerateOptions) -> GenerateResult<()> {
    let out_path = config.get_generated_out_path();
    let destination = config.dir().join(out_path);
    let generated_dir = destination.parent();

    if let Some(dir) = generated_dir {
        std::fs::DirBuilder::new().recursive(true).create(dir)?;
    } else {
        todo!();
    }

    // TODO: Test case where provided input is './something.nix'
    let num_components = destination.components().count();

    let prefix = (0..(num_components - 1))
        .map(|_| "../")
        .collect::<Vec<_>>()
        .join("");

    let mut buf = String::new();

    let attrset = find_nix_path_attrset(&config);

    write!(&mut buf, "{{")?;

    for (name, path_buf) in attrset.iter() {
        let path = path_buf.to_string_lossy();
        write!(&mut buf, "  {name} = {prefix}{path};")?;
    }

    write!(&mut buf, "}}")?;

    let mut file = tempfile::tempfile()?;

    file.write_all(buf.as_bytes())?;

    let mut destination_file = std::fs::File::create(destination)?;

    std::io::copy(&mut file, &mut destination_file)?;

    Ok(())
}
