{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "direnv.generate-nix-index";
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
