{
  pkgs,
  _,
  ...
}:
pkgs.writeShellApplication {
  name = "root.local-ci";

  runtimeInputs = [
    _.root.check
  ];

  text = builtins.readFile ./run.sh;
}
