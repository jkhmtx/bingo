{
  pkgs,
  _,
  ...
}:
pkgs.writeShellApplication {
  name = "root.check";

  runtimeInputs = [
    _.root.format
    _.root.lint
  ];

  text = builtins.readFile ./run.sh;
}
