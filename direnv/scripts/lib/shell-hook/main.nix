{pkgs, ...}:
pkgs.writeShellApplication {
  name = "direnv.lib.shell-hook";

  text = builtins.readFile ./run.sh;
}
