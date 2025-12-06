{
  _,
  pkgs,
  ...
}:
pkgs.writeShellApplication {
  name = "root.format-js";

  runtimeInputs = [
    _.frontend.format
  ];

  text = builtins.readFile ./run.sh;
}
