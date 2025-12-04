{pkgs, ...}:
pkgs.symlinkJoin {
  name = "dev-shell";
  paths = [
    # binary pkgs for general usage
    pkgs.nodejs
    pkgs.biome
  ];
}
