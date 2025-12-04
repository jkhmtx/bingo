{
  pkgs,
  projectNamespace,
  ...
}:
pkgs.writeShellApplication {
  name = "frontend.format";
  runtimeInputs = [
    pkgs.git
    projectNamespace.frontend.lib.biome
  ];

  text = builtins.readFile ./run.sh;
}
