{
  projectNamespace,
  pkgs,
  ...
}:
pkgs.writeShellApplication {
  name = "root.format-js";

  runtimeInputs = [
    projectNamespace.frontend.format
  ];

  text = builtins.readFile ./run.sh;
}
