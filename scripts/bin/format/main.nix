{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "root.format";

  runtimeInputs = [
    projectNamespace.root.format-js
    projectNamespace.root.format-nix
    projectNamespace.root.format-shell
    projectNamespace.root.format-yaml
  ];

  text = builtins.readFile ./run.sh;
}
