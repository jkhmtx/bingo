{
  pkgs,
  mrx,
  ...
}:
pkgs.symlinkJoin {
  name = "shell";
  paths = [
    # binary pkgs for general usage
    mrx
    pkgs.biome
    pkgs.coreutils
    pkgs.nodejs
  ];
}
