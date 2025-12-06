{
  nixpkgs,
  _,
  ...
}:
nixpkgs.writeShellApplication {
  name = "mrx";
  runtimeInputs = [
    _.root.build-shell
    _.root.find-watch-files
    _.root.generate-nix
    _.root.handle-stale-dependency-graph-nodes
    _.root.lib.build-and-symlink-derivations
    _.root.post
  ];

  runtimeEnv = {
    BUILD_AND_SYMLINK = _.root.lib.build-and-symlink-derivations.name;
    BUILD_SHELL = _.root.build-shell.name;
    FIND_WATCH_FILES = _.root.find-watch-files.name;
    GENERATE_NIX = _.root.generate-nix.name;
    HANDLE_STALE_DEPENDENCY_GRAPH_NODES = _.root.handle-stale-dependency-graph-nodes.name;
    POST = _.root.post.name;
  };
  text = builtins.readFile ./run.sh;
}
