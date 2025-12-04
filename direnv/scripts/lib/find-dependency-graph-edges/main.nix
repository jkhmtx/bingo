{
  pkgs,
  projectNamespace,
  ...
}:
projectNamespace.root.util.with-tee {
  name = "direnv.lib.find-dependency-graph-edges";
  drv = pkgs.writeShellApplication {
    name = "direnv.lib.find-dependency-graph-edges.inner";

    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
      pkgs.gnugrep
      pkgs.gnused
      projectNamespace.direnv.lib.find-generated-nix-raw-attrset
    ];

    runtimeEnv = {
      FIND_GENERATED_NIX_RAW_ATTRSET = projectNamespace.direnv.lib.find-generated-nix-raw-attrset.name;
    };

    text = builtins.readFile ./run.sh;
  };
}
