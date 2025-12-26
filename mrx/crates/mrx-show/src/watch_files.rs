use mrx_utils::{Config, fs::AbsoluteFilePathBuf, graph::Graph};

pub fn watch_files(config: Config) {
    let graph = Graph::new(config.get_entrypoint().unwrap()).unwrap();

    let generated_out_path =
        AbsoluteFilePathBuf::try_from(config.get_generated_out_path().to_path_buf()).unwrap();

    let mut bufs = graph
        .as_nodes()
        .into_iter()
        .map(|node| node.as_path())
        .filter(|path| **path != generated_out_path)
        .map(|path| path.as_path())
        .collect::<Vec<_>>();
    bufs.sort();
    for buf in bufs.iter() {
        println!("{}", buf.to_string_lossy());
    }
}
