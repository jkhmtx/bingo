{
  pkgs,
  _,
  ...
}:
pkgs.writeShellApplication {
  name = "root.lint-js";

  runtimeInputs = [
    _.frontend.lint
  ];

  text = builtins.readFile ./run.sh;
}
