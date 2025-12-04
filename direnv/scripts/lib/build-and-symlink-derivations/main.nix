{pkgs, ...}:
pkgs.writeShellApplication {
  name = "direnv.lib.build-and-symlink-derivations.inner";

  runtimeInputs = [
    pkgs.coreutils
    pkgs.findutils
    pkgs.git
  ];

  text = builtins.readFile ./run.sh;
}
