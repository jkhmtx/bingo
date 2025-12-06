{pkgs, ...}:
pkgs.symlinkJoin {
  name = "shell";
  paths = [
    # binary pkgs for general usage
    pkgs.biome
    pkgs.coreutils
    pkgs.nodejs
  ];
}
