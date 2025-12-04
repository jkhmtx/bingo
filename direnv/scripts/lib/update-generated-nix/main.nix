{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "direnv.lib.update-generated-nix";
  runtimeInputs = [
    pkgs.coreutils
    pkgs.gnused
    projectNamespace.direnv.lib.find-generated-nix-raw-attrset
  ];

  runtimeEnv = {
    FIND_GENERATED_NIX_RAW_ATTRSET = projectNamespace.direnv.lib.find-generated-nix-raw-attrset.name;
  };
  text = builtins.readFile ./run.sh;
}
