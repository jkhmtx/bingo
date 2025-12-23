use std::fs::File;
use std::io::Write as _;
use std::path::Path;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum WriteWithFallbackError {
    #[error("writing tempfile failed: `{0}`")]
    Failed(std::io::Error),
    #[error("invalid destination: `{0}`")]
    InvalidDest(std::io::Error),
    #[error("Rolled back: `${0}`")]
    RolledBack(std::io::Error),
}

type WriteWithFallbackResult<T> = Result<T, WriteWithFallbackError>;

/// Makes a tempfile A and writes [`bytes`] to it.
/// Makes a tempfile B and copies [`dest`] to it.
/// If copying A to [`dest`] fails, an attempt is made to copy B to [`dest`].
pub fn write_with_fallback(bytes: &[u8], dest: &Path) -> WriteWithFallbackResult<()> {
    use std::io::copy;

    let mut dest_file = {
        use std::io::ErrorKind;
        match File::open(dest) {
            Ok(f) => Ok(f),
            Err(e) if e.kind() == ErrorKind::NotFound => {
                File::create(dest).map_err(|e| WriteWithFallbackError::InvalidDest(e))
            }
            Err(e) => Err(WriteWithFallbackError::Failed(e)),
        }
    }?;

    let mut a = tempfile::tempfile().map_err(WriteWithFallbackError::Failed)?;
    let mut b = tempfile::tempfile().map_err(WriteWithFallbackError::Failed)?;

    a.write_all(bytes).map_err(WriteWithFallbackError::Failed)?;

    copy(&mut dest_file, &mut b).map_err(WriteWithFallbackError::Failed)?;

    copy(&mut a, &mut dest_file)
        .map_err(|e| match (e, copy(&mut b, &mut dest_file)) {
            (e, Ok(_)) => WriteWithFallbackError::RolledBack(e),
            (e, Err(_)) => WriteWithFallbackError::Failed(e),
        })
        .map(|_| {})
}
