{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "direnv.find-watch-files";
  runtimeInputs = [
    pkgs.coreutils
    pkgs.gnused
    projectNamespace.direnv.lib.find-dependency-graph-edges
  ];

  runtimeEnv = {
    FIND_DEPENDENCY_GRAPH_EDGES = projectNamespace.direnv.lib.find-dependency-graph-edges.name;
  };
  text = builtins.readFile ./run.sh;
}
