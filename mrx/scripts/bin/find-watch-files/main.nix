{
  nixpkgs,
  _,
  ...
}:
nixpkgs.writeShellApplication {
  name = "root.find-watch-files";
  runtimeInputs = [
    nixpkgs.coreutils
    nixpkgs.gnused
    _.root.lib.find-dependency-graph-edges
    _.root.lib.generate-ignore-patterns-file
  ];

  runtimeEnv = {
    FIND_DEPENDENCY_GRAPH_EDGES = _.root.lib.find-dependency-graph-edges.name;
    GENERATE_IGNORE_PATTERNS_FILE = _.root.lib.generate-ignore-patterns-file.name;
  };
  text = builtins.readFile ./run.sh;
}
