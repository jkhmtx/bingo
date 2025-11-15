{pkgs, ...}:
pkgs.symlinkJoin {
  name = "dev-shell";
  paths = [
    pkgs.bc
    pkgs.viewnior
    pkgs.ghostscript
    pkgs.imagemagickBig
  ];
}
