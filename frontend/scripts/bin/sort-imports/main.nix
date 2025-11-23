{pkgs, ...}:
pkgs.writeShellApplication {
  name = "frontend.sort-imports";
  runtimeInputs = [
    pkgs.git
    pkgs.gnused
    pkgs.moreutils
  ];
  text = builtins.readFile ./run.sh;
}
