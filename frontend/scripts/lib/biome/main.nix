{pkgs, ...}:
pkgs.writeShellApplication {
  name = "frontend.lib.biome";
  runtimeInputs = [
    pkgs.biome
  ];

  runtimeEnv = {
    BIOME_JSONC = ../../../biome.jsonc;
  };

  text = builtins.readFile ./run.sh;
}
