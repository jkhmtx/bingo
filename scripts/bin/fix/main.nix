{
  pkgs,
  _,
  ...
}:
pkgs.writeShellApplication {
  name = "root.fix";

  runtimeInputs = [_.root.check];

  text = builtins.readFile ./run.sh;
}
