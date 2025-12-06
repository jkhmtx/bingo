{
  nixpkgs,
  infallible,
  ...
}:
nixpkgs.writeShellApplication {
  name = "root.generate-nix";
  runtimeInputs = [
    nixpkgs.coreutils
    nixpkgs.gnused
    infallible.find-generated-nix-raw-attrset
    infallible.get-config-value
  ];

  runtimeEnv = {
    FIND_GENERATED_NIX_RAW_ATTRSET = infallible.find-generated-nix-raw-attrset.name;
    GET_CONFIG_VALUE = infallible.get-config-value.name;
  };
  text = builtins.readFile ./run.sh;
}
