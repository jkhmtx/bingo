{
  pkgs,
  projectNamespace,
  ...
}:
projectNamespace.root.util.with-tee {
  name = "direnv.lib.find-stale-dependency-graph-nodes";
  drv = pkgs.writeShellApplication {
    name = "direnv.lib.find-stale-dependency-graph-nodes.inner";

    runtimeInputs = [
      pkgs.git
      projectNamespace.direnv.lib.find-generated-nix-raw-attrset
      projectNamespace.direnv.lib.mtime-database
    ];

    runtimeEnv = {
      FIND_GENERATED_NIX_RAW_ATTRSET = projectNamespace.direnv.lib.find-generated-nix-raw-attrset.name;
      MTIME_DATABASE = projectNamespace.direnv.lib.mtime-database.name;
    };

    text = builtins.readFile ./run.sh;
  };
}
