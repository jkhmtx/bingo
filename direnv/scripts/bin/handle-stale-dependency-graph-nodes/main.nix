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
    _.root.lib.find-stale-dependency-graph-nodes
    _.root.lib.build-and-symlink-derivations
    _.root.lib.get-config-value
  ];
  runtimeEnv = {
    FIND_STALE_DEPENDENCY_GRAPH_NODES = _.root.lib.find-stale-dependency-graph-nodes.name;
    BUILD_AND_SYMLINK = _.root.lib.build-and-symlink-derivations.name;
    GET_CONFIG_VALUE = _.root.lib.get-config-value.name;
  };
  text = builtins.readFile ./run.sh;
}
