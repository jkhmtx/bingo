{pkgs, ...}:
pkgs.symlinkJoin {
  name = "dev-shell";
  paths = [
    # binary pkgs for general usage
    pkgs.biome
    pkgs.coreutils
    pkgs.nodejs
  ];
}
