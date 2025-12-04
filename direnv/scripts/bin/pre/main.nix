{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "direnv.pre";
  runtimeInputs = [
    pkgs.coreutils
    pkgs.gnugrep
    projectNamespace.direnv.lib.build-and-symlink-derivations
    projectNamespace.direnv.lib.build-lazy-derivations
    projectNamespace.direnv.lib.build-shell
    projectNamespace.direnv.lib.find-dependency-graph-edges
    projectNamespace.direnv.lib.find-generated-nix-raw-attrset
    projectNamespace.direnv.lib.find-stale-dependency-graph-nodes
    projectNamespace.direnv.lib.update-generated-nix
    projectNamespace.direnv.lib.watch-files
  ];
  runtimeEnv = {
    BUILD_AND_SYMLINK = projectNamespace.direnv.lib.build-and-symlink-derivations.name;
    BUILD_LAZY_DERIVATIONS = projectNamespace.direnv.lib.build-lazy-derivations.name;
    BUILD_SHELL = projectNamespace.direnv.lib.build-shell.name;
    FIND_DEPENDENCY_GRAPH_EDGES = projectNamespace.direnv.lib.find-dependency-graph-edges.name;
    FIND_GENERATED_NIX_RAW_ATTRSET = projectNamespace.direnv.lib.find-generated-nix-raw-attrset.name;
    FIND_STALE_DEPENDENCY_GRAPH_NODES = projectNamespace.direnv.lib.find-stale-dependency-graph-nodes.name;
    UPDATE_GENERATED_NIX = projectNamespace.direnv.lib.update-generated-nix.name;
    WATCH_FILES = projectNamespace.direnv.lib.watch-files.name;
  };
  text = builtins.readFile ./run.sh;
}
