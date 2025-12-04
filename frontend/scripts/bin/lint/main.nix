{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "frontend.lint";
  runtimeInputs = [
    pkgs.git
    projectNamespace.frontend.lib.biome
  ];

  text = builtins.readFile ./run.sh;
}
