{
  nixpkgs,
  _,
  ...
}:
nixpkgs.symlinkJoin {
  name = "shell";
  paths = [
    _.pkgs.mrx
    _.pkgs.rust
    nixpkgs.coreutils
    nixpkgs.gcc
  ];
}
