use std::path::PathBuf;

use mrx_utils::{Config, find_nix_path_attrset};

fn walk_for_file_nodes(node: rnix::SyntaxNode, paths: &mut Vec<String>) {
    if node.kind() == rnix::SyntaxKind::NODE_PATH {
        let text = node.text().to_string();
        // If the last component in a path is the character '.',
        // it means it refers to a directory, not a file.
        // e.g. '.', '../.'
        if !text.ends_with(".") {
            paths.push(text);
        }
    }

    for child in node.children() {
        walk_for_file_nodes(child, paths);
    }
}

fn find_files(config: Config) -> Vec<PathBuf> {
    let path_attrset = find_nix_path_attrset(&config);
    let paths = path_attrset.values();

    let mut edges = paths.clone().cloned().collect::<Vec<_>>();

    for path in paths {
        let file = std::fs::read(path).unwrap();
        let file = String::from_utf8(file).unwrap();

        // TODO: What happens when there's a main.nix in the root?
        let dir = path.parent().unwrap();

        let root = rnix::Root::parse(&file).syntax();
        let mut paths_in_file = vec![];
        walk_for_file_nodes(root, &mut paths_in_file);

        for path_in_file in paths_in_file {
            let normalized = path_in_file.replace("../", "").replace("./", "");

            let n_ups = normalized.chars().filter(|c| c == &'/').count();
            let o_ups = path_in_file.chars().filter(|c| c == &'/').count();

            let dir_ups = o_ups - n_ups - 1;

            let mut dir = dir;
            for _ in 0..dir_ups {
                dir = dir.parent().unwrap();
            }

            edges.push(dir.join(normalized));
        }
    }

    edges
}

pub fn watch_files(config: Config) {
    let mut bufs = find_files(config);
    bufs.sort();
    for buf in bufs.iter() {
        println!("{}", buf.to_string_lossy());
    }
}
