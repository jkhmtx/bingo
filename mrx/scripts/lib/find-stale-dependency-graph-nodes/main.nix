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
    _.root.lib.find-dependency-graph-edges
    _.root.lib.find-generated-nix-raw-attrset
    _.root.lib.generate-ignore-patterns-file
    _.root.lib.get-config-value
    _.root.lib.mtime-database
  ];
  runtimeEnv = {
    FIND_DEPENDENCY_GRAPH_EDGES = _.root.lib.find-dependency-graph-edges.name;
    FIND_GENERATED_NIX_RAW_ATTRSET = _.root.lib.find-generated-nix-raw-attrset.name;
    GENERATE_IGNORE_PATTERNS_FILE = _.root.lib.generate-ignore-patterns-file.name;
    GET_CONFIG_VALUE = _.root.lib.get-config-value.name;
    MTIME_DATABASE = _.root.lib.mtime-database.name;
  };
  text = builtins.readFile ./run.sh;
}
