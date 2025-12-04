{pkgs, ...}:
pkgs.writeShellApplication {
  name = "direnv.lib.mtime-database";

  text = builtins.readFile ./run.sh;
}
