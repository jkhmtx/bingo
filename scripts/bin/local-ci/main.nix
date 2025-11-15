{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "root.local-ci";

  runtimeInputs = [
    projectNamespace.root.check
  ];

  text = builtins.readFile ./run.sh;
}
