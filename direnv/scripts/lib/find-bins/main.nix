{
  pkgs,
  projectNamespace,
  ...
}:
projectNamespace.root.util.with-tee {
  name = "direnv.lib.find-bins";
  drv = pkgs.writeShellApplication {
    name = "direnv.lib.find-bins.inner";

    runtimeInputs = [
      projectNamespace.direnv.lib.find-generated-nix-raw-attrset
    ];
    runtimeEnv = {
      FIND_GENERATED_NIX_RAW_ATTRSET = projectNamespace.direnv.lib.find-generated-nix-raw-attrset.name;
    };

    text = builtins.readFile ./run.sh;
  };
}
