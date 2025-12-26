use std::{collections::HashMap, path::PathBuf};

mod error;
use error::GraphError;

use crate::{
    Entrypoint,
    fs::{AbsoluteFilePathBuf, AbsoluteFilePathBufError},
};

pub struct Node {
    path: AbsoluteFilePathBuf,
    edges: Vec<usize>,
}

impl Node {
    fn new(path: AbsoluteFilePathBuf) -> Self {
        Self {
            path,
            edges: vec![],
        }
    }

    pub fn as_path(&self) -> &AbsoluteFilePathBuf {
        &self.path
    }
}

pub struct Graph {
    nodes: Vec<Node>,
    todo_node_indexes: Vec<usize>,
    by_path: HashMap<AbsoluteFilePathBuf, usize>,
}

#[derive(Clone)]
enum NodeReference {
    File(AbsoluteFilePathBuf),
    Derivation(String, AbsoluteFilePathBuf),
}

impl NodeReference {
    fn as_path(&self) -> &AbsoluteFilePathBuf {
        match self {
            Self::File(buf) => buf,
            Self::Derivation(_, buf) => buf,
        }
    }
}

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

fn references_within(path: &AbsoluteFilePathBuf) -> Result<Vec<NodeReference>, GraphError> {
    let file = std::fs::read(path.as_path()).unwrap();
    let file = String::from_utf8(file).unwrap();

    let root = rnix::Root::parse(&file).syntax();
    let mut paths_in_file = vec![];
    walk_for_file_nodes(root, &mut paths_in_file);

    paths_in_file
        .into_iter()
        .map(PathBuf::from)
        .map(|buf| {
            Ok(
                AbsoluteFilePathBuf::try_from_relative(&buf, path.to_path_buf())
                    .map(NodeReference::File)?,
            )
        })
        .collect()
}

impl Graph {
    pub fn new(entrypoint: Entrypoint) -> Result<Self, GraphError> {
        let path =
            AbsoluteFilePathBuf::try_from(entrypoint.as_path().clone()).map_err(|e| match e {
                AbsoluteFilePathBufError::NotFound => GraphError::NoEntrypoint,
                AbsoluteFilePathBufError::NotAFile => GraphError::IllegalNode,
                AbsoluteFilePathBufError::Io(error) => GraphError::Io(error),
            })?;
        let node = Node::new(path.clone());
        let by_path = HashMap::from([(path.clone(), 0)]);

        let mut graph = Self {
            nodes: vec![node],
            todo_node_indexes: vec![0],
            by_path,
        };

        Graph::process(&mut graph, &path)?;

        Ok(graph)
    }

    pub fn as_nodes(&self) -> &Vec<Node> {
        &self.nodes
    }

    fn try_add(&mut self, reference: NodeReference) {
        let path = reference.as_path();
        let idx = self.by_path.get(path);
        let curr_idx = self.nodes.len();

        match idx {
            Some(idx) => {
                self.nodes.last_mut().unwrap().edges.push(*idx);
            }
            None => {
                let mut node = Node::new(path.clone());
                node.edges.push(curr_idx);
                self.by_path.insert(path.clone(), curr_idx);
                self.nodes.push(node);
            }
        }
    }

    fn process(&mut self, path: &AbsoluteFilePathBuf) -> Result<(), GraphError> {
        for reference in references_within(&path)? {
            self.try_add(reference.clone());
            self.process(reference.as_path())?;
        }

        Ok(())
    }
}
