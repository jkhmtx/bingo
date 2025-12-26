use thiserror::Error;

use crate::fs::AbsoluteFilePathBufError;

#[derive(Debug, Error)]
pub enum GraphError {
    #[error("No fallback entrypoint 'flake.nix' or 'default.nix' found")]
    NoEntrypoint,
    #[error("Illegal node")]
    IllegalNode,
    #[error("Io error: {0}")]
    Io(#[from] std::io::Error),
}

impl From<AbsoluteFilePathBufError> for GraphError {
    fn from(value: AbsoluteFilePathBufError) -> Self {
        match value {
            AbsoluteFilePathBufError::Io(e) => Self::Io(e),
            _ => Self::IllegalNode,
        }
    }
}
