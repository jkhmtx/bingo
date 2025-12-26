use std::{collections::HashMap, path::PathBuf};

mod error;
use error::GraphError;

use crate::{
    Entrypoint,
    fs::{AbsoluteFilePathBuf, AbsoluteFilePathBufError},
};

#[derive(Clone, Debug)]
pub struct Node {
    path: AbsoluteFilePathBuf,
}

impl Node {
    fn new(path: AbsoluteFilePathBuf) -> Self {
        Self { path }
    }

    pub fn as_path(&self) -> &AbsoluteFilePathBuf {
        &self.path
    }
}

#[derive(Debug)]
pub struct Graph {
    nodes: Vec<Node>,
    edges: Vec<(usize, usize)>,
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

#[derive(Debug)]
pub struct Edge(pub Node, pub Node);

impl Graph {
    fn new(path: AbsoluteFilePathBuf) -> Self {
        Self {
            nodes: vec![Node::new(path.clone())],
            edges: vec![],
            by_path: HashMap::from([(path.clone(), 0)]),
        }
    }

    pub fn as_nodes(&self) -> &Vec<Node> {
        &self.nodes
    }

    pub fn to_edges(&self) -> Vec<Edge> {
        self.edges
            .iter()
            .map(|(a, b)| Edge(self.nodes[*a].clone(), self.nodes[*b].clone()))
            .collect()
    }

    fn add_edge(&mut self, from: usize, to: usize) {
        self.edges.push((from, to));
    }

    fn process(&mut self, idx: usize) -> Result<(), GraphError> {
        let node = &self.nodes[idx];
        for reference in references_within(node.as_path())? {
            let path = reference.as_path();
            let curr_idx = self.nodes.len();

            if let Some(next_idx) = match self.by_path.get(path) {
                Some(old_idx) => {
                    self.add_edge(idx, *old_idx);
                    None
                }
                None => {
                    self.by_path.insert(path.clone(), curr_idx);
                    self.nodes.push(Node::new(path.clone()));
                    self.add_edge(idx, curr_idx);
                    Some(curr_idx)
                }
            } {
                self.process(next_idx)?;
            }
        }

        Ok(())
    }
}

impl TryFrom<Entrypoint> for Graph {
    type Error = GraphError;

    fn try_from(value: Entrypoint) -> Result<Self, Self::Error> {
        let path = AbsoluteFilePathBuf::try_from(value.as_path().clone()).map_err(|e| match e {
            AbsoluteFilePathBufError::NotFound => GraphError::NoEntrypoint,
            AbsoluteFilePathBufError::NotAFile => GraphError::IllegalNode,
            AbsoluteFilePathBufError::Io(error) => GraphError::Io(error),
        })?;

        let mut graph = Graph::new(path);

        graph.process(0)?;

        Ok(graph)
    }
}
