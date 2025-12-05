{
  nixpkgs,
  _,
  ...
}:
_.root.util.with-tee {
  name = "root.lib.find-bins";
  drv = nixpkgs.writeShellApplication {
    name = "root.lib.find-bins.inner";

    runtimeInputs = [
      _.root.lib.find-generated-nix-raw-attrset
    ];
    runtimeEnv = {
      FIND_GENERATED_NIX_RAW_ATTRSET = _.root.lib.find-generated-nix-raw-attrset.name;
    };

    text = builtins.readFile ./run.sh;
  };
}
