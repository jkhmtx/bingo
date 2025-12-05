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
    _.root.lib.build-and-symlink-derivations
    _.root.lib.find-bins
    _.root.lib.find-generated-nix-raw-attrset
  ];

  runtimeEnv = {
    BUILD_AND_SYMLINK = _.root.lib.build-and-symlink-derivations.name;
    FIND_BINS = _.root.lib.find-bins.name;
    FIND_GENERATED_NIX_RAW_ATTRSET = _.root.lib.find-generated-nix-raw-attrset.name;
  };
  text = builtins.readFile ./run.sh;
}
