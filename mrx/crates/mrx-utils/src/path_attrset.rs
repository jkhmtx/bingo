use std::{
    collections::HashMap,
    ops::{Deref, DerefMut},
    path::PathBuf,
};

#[derive(Debug, PartialEq)]
pub struct PathAttrset(HashMap<String, PathBuf>);

impl PathAttrset {
    pub fn new() -> Self {
        Self(HashMap::new())
    }
}

impl Deref for PathAttrset {
    type Target = HashMap<String, PathBuf>;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl DerefMut for PathAttrset {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}
