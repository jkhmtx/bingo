{
  nixpkgs,
  _,
  ...
}:
nixpkgs.writeShellApplication {
  name = "root.generate-nix";
  runtimeInputs = [
    nixpkgs.coreutils
    nixpkgs.gnused
    _.root.lib.find-generated-nix-raw-attrset
  ];

  runtimeEnv = {
    FIND_GENERATED_NIX_RAW_ATTRSET = _.root.lib.find-generated-nix-raw-attrset.name;
  };
  text = builtins.readFile ./run.sh;
}
