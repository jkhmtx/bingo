{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "direnv.handle-stale-dependency-graph-nodes";
  runtimeInputs = [
    pkgs.coreutils
    pkgs.gnugrep
    projectNamespace.direnv.lib.build-and-symlink-derivations
    projectNamespace.direnv.lib.find-dependency-graph-edges
    projectNamespace.direnv.lib.find-generated-nix-raw-attrset
    projectNamespace.direnv.lib.mtime-database
  ];
  runtimeEnv = {
    BUILD_AND_SYMLINK = projectNamespace.direnv.lib.build-and-symlink-derivations.name;
    FIND_DEPENDENCY_GRAPH_EDGES = projectNamespace.direnv.lib.find-dependency-graph-edges.name;
    FIND_GENERATED_NIX_RAW_ATTRSET = projectNamespace.direnv.lib.find-generated-nix-raw-attrset.name;
    MTIME_DATABASE = projectNamespace.direnv.lib.mtime-database.name;
  };
  text = builtins.readFile ./run.sh;
}
