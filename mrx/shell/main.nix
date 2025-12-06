{pkgs, ...}:
pkgs.symlinkJoin {
  name = "shell";
  paths = [
    pkgs.coreutils
  ];
}
