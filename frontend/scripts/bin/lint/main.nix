{
  pkgs,
  _,
  ...
}:
pkgs.writeShellApplication {
  name = "frontend.lint";
  runtimeInputs = [
    pkgs.git
    _.frontend.lib.biome
  ];

  text = builtins.readFile ./run.sh;
}
