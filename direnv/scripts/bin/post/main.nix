{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "direnv.post";
  runtimeInputs = [
    pkgs.coreutils
    pkgs.findutils
    pkgs.gnused
    projectNamespace.direnv.lib.find-bins
  ];

  runtimeEnv = {
    FIND_BINS = projectNamespace.direnv.lib.find-bins.name;
  };
  text = builtins.readFile ./run.sh;
}
