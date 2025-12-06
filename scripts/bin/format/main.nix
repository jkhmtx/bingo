{
  pkgs,
  _,
  ...
}:
pkgs.writeShellApplication {
  name = "root.format";

  runtimeInputs = [
    _.root.format-js
    _.root.format-nix
    _.root.format-shell
    _.root.format-yaml
  ];

  text = builtins.readFile ./run.sh;
}
