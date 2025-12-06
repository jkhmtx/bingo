{
  pkgs,
  _,
  ...
}:
pkgs.writeShellApplication {
  name = "root.lint";

  runtimeInputs = [
    _.root.lint-github-actions
    _.root.lint-js
    _.root.lint-shell
  ];

  text = builtins.readFile ./run.sh;
}
