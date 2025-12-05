{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "direnv.build-shell";
  runtimeInputs = [
    pkgs.coreutils
    pkgs.gnused
    projectNamespace.direnv.lib.build-and-symlink-derivations
    projectNamespace.direnv.lib.find-bins
    projectNamespace.direnv.lib.find-generated-nix-raw-attrset
  ];

  runtimeEnv = {
    BUILD_AND_SYMLINK = projectNamespace.direnv.lib.build-and-symlink-derivations.name;
    FIND_BINS = projectNamespace.direnv.lib.find-bins.name;
    FIND_GENERATED_NIX_RAW_ATTRSET = projectNamespace.direnv.lib.find-generated-nix-raw-attrset.name;
  };
  text = builtins.readFile ./run.sh;
}
