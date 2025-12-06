{
  nixpkgs,
  _,
  ...
}:
nixpkgs.writeShellApplication {
  name = "build-shell";
  runtimeInputs = [
    nixpkgs.coreutils
    nixpkgs.gnused
    nixpkgs.jq
    _.root.lib.find-bins
    _.root.lib.find-generated-nix-raw-attrset
    _.root.lib.get-config-value
  ];

  runtimeEnv = {
    BUILD_AND_SYMLINK = ".mrx/cmd/bin/mrx cache-build";
    FIND_BINS = _.root.lib.find-bins.name;
    FIND_GENERATED_NIX_RAW_ATTRSET = _.root.lib.find-generated-nix-raw-attrset.name;
    GET_CONFIG_VALUE = _.root.lib.get-config-value.name;
  };
  text = builtins.readFile ./run.sh;
}
