{nixpkgs, ...}:
nixpkgs.writeShellApplication {
  name = "root.lib.get-config-value";

  runtimeInputs = [nixpkgs.tomlq];

  text = builtins.readFile ./run.sh;
}
