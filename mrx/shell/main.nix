{
  nixpkgs,
  _,
  ...
}:
nixpkgs.symlinkJoin {
  name = "shell";
  paths = [
    nixpkgs.coreutils
    nixpkgs.gcc
    _.rust
    _.package
  ];
}
