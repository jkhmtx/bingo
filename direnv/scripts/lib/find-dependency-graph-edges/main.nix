{
  nixpkgs,
  _,
  ...
}:
_.root.util.with-tee {
  name = "root.lib.find-dependency-graph-edges";
  drv = nixpkgs.writeShellApplication {
    name = "root.lib.find-dependency-graph-edges.inner";

    runtimeInputs = [
      nixpkgs.coreutils
      nixpkgs.git
      nixpkgs.gnugrep
      nixpkgs.gnused
      _.root.lib.find-generated-nix-raw-attrset
      _.root.lib.get-config-value
    ];

    runtimeEnv = {
      FIND_GENERATED_NIX_RAW_ATTRSET = _.root.lib.find-generated-nix-raw-attrset.name;
      GET_CONFIG_VALUE = _.root.lib.get-config-value.name;
    };

    text = builtins.readFile ./run.sh;
  };
}
