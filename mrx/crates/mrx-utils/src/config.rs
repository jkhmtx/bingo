use serde::Deserialize;
use std::{fs, path::PathBuf};

use thiserror::Error;

#[derive(Debug, Clone)]
pub struct Config {
    path: PathBuf,
    toml: ConfigToml,

    default_generated_out_path: PathBuf,
}

#[derive(Deserialize, Debug, Clone)]
struct ConfigToml {
    ignore_file: Option<PathBuf>,
    generated_out_path: Option<PathBuf>,
}

#[derive(Debug, Error)]
pub enum ConfigValueError {
    #[error("value `{0}` is missing")]
    MissingValue(String),
    #[error("Io")]
    Io(#[from] std::io::Error),
}

type ConfigValueResult<T> = Result<T, ConfigValueError>;

impl Config {
    pub fn dir_absolute(&self) -> PathBuf {
        fs::canonicalize(&self.dir()).unwrap()
    }
    pub fn dir(&self) -> PathBuf {
        self.path
            .parent()
            .filter(|p| p.exists())
            .map(|p| p.to_path_buf())
            .unwrap_or_else(|| PathBuf::from("./"))
    }
    pub fn get_ignore_file(&self) -> ConfigValueResult<&PathBuf> {
        self.toml
            .ignore_file
            .as_ref()
            .ok_or(ConfigValueError::MissingValue("ignore_file".to_string()))
    }

    pub fn get_generated_out_path(&self) -> &PathBuf {
        self.toml
            .generated_out_path
            .as_ref()
            .unwrap_or(&self.default_generated_out_path)
    }
}

#[derive(Debug, Error)]
pub enum ConfigInitError {
    #[error("file `{0}` not found")]
    NotFound(PathBuf),
    #[error("invalid toml: {0}")]
    InvalidToml(#[from] toml::de::Error),
    #[error("error reading config file")]
    ReadError(#[from] std::io::Error),
}

impl TryFrom<PathBuf> for Config {
    type Error = ConfigInitError;

    fn try_from(path: PathBuf) -> Result<Self, Self::Error> {
        let file = fs::read(&path).map_err(|e| {
            use std::io::ErrorKind as IoErr;
            match e.kind() {
                IoErr::NotFound => ConfigInitError::NotFound(path.clone()),
                _ => ConfigInitError::ReadError(e),
            }
        })?;
        let toml: ConfigToml = toml::from_slice(&file)?;

        Ok(Self {
            path,
            toml,
            default_generated_out_path: PathBuf::from("mrx.generated.nix"),
        })
    }
}
