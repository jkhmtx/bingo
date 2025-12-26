use std::path::{Path, PathBuf};

mod absolute_file_path_buf;
mod write_with_fallback;
pub use absolute_file_path_buf::*;
pub use write_with_fallback::{WriteWithFallbackError, write_with_fallback};

pub fn pathbuf_if_exists(path: &str) -> Option<PathBuf> {
    let path = PathBuf::from(path);

    if std::fs::exists(&path).ok().is_some_and(|exists| exists) {
        Some(path)
    } else {
        None
    }
}

pub fn mk_dir(path: &Path) -> Result<(), std::io::Error> {
    std::fs::DirBuilder::new().recursive(true).create(path)
}

pub fn recreate_dir(path: &Path) -> Result<(), std::io::Error> {
    std::fs::remove_dir_all(path).and_then(|_| mk_dir(path))
}
