{
  pkgs,
  _,
  ...
}:
pkgs.writeShellApplication {
  name = "frontend.format";
  runtimeInputs = [
    pkgs.git
    _.frontend.lib.biome
  ];

  text = builtins.readFile ./run.sh;
}
