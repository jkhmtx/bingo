use std::path::PathBuf;

use serde::Deserialize;

#[derive(Deserialize)]
struct NixBuildOutputInner {
    out: Option<String>,
    bin: Option<String>,
}

#[derive(Deserialize)]
struct NixBuildOutput {
    outputs: NixBuildOutputInner,
}

#[derive(Deserialize)]
pub struct NixBuildStructuredStdout {
    inner: Vec<NixBuildOutput>,
}

impl NixBuildStructuredStdout {
    pub fn try_from(s: &[u8]) -> Result<NixBuildStructuredStdout, serde_json::Error> {
        Ok(Self { inner: vec![] })
    }

    pub fn into_path_strs(self) -> Option<Vec<String>> {
        self.inner
            .into_iter()
            .map(|o| {
                o.outputs
                    .bin
                    .or(o.outputs.out.map(|out| format!("{out}/bin")))
            })
            .collect()
    }
}
