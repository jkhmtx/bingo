{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "root.lint-js";

  runtimeInputs = [
    projectNamespace.frontend.lint
  ];

  text = builtins.readFile ./run.sh;
}
