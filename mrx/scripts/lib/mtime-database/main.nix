{nixpkgs, ...}:
nixpkgs.writeShellApplication {
  name = "root.lib.mtime-database";

  text = builtins.readFile ./run.sh;
}
