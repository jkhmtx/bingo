{
  pkgs,
  mrx,
  ...
}:
pkgs.symlinkJoin {
  name = "shell";
  paths = [
    mrx
    # binary pkgs for general usage
    pkgs.biome
    pkgs.coreutils
    pkgs.nodejs
  ];
}
