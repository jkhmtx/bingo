use std::path::Path;

mod write_with_fallback;
pub use write_with_fallback::{WriteWithFallbackError, write_with_fallback};

pub fn mk_dir(path: &Path) -> Result<(), std::io::Error> {
    std::fs::DirBuilder::new().recursive(true).create(path)
}

pub fn recreate_dir(path: &Path) -> Result<(), std::io::Error> {
    std::fs::remove_dir_all(path).and_then(|_| mk_dir(path))
}
