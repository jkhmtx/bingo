#[derive(Debug, Copy, Clone)]
pub struct Config {}

impl Config {
    pub fn new() -> Self {
        Config {}
    }

    pub fn get_ignore_file(&self) -> Option<String> {
        None
        // Some("mrx.ignore.lst".to_string())
    }
}
