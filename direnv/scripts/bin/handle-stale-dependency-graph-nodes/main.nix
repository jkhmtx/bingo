{
  nixpkgs,
  _,
  ...
}:
nixpkgs.writeShellApplication {
  name = "root.handle-stale-dependency-graph-nodes";
  runtimeInputs = [
    nixpkgs.coreutils
    nixpkgs.gnugrep
    _.root.lib.build-and-symlink-derivations
    _.root.lib.find-dependency-graph-edges
    _.root.lib.find-generated-nix-raw-attrset
    _.root.lib.mtime-database
  ];
  runtimeEnv = {
    BUILD_AND_SYMLINK = _.root.lib.build-and-symlink-derivations.name;
    FIND_DEPENDENCY_GRAPH_EDGES = _.root.lib.find-dependency-graph-edges.name;
    FIND_GENERATED_NIX_RAW_ATTRSET = _.root.lib.find-generated-nix-raw-attrset.name;
    MTIME_DATABASE = _.root.lib.mtime-database.name;
  };
  text = builtins.readFile ./run.sh;
}
