{nixpkgs, ...}:
nixpkgs.writeShellApplication {
  name = "root.generate";
  runtimeInputs = [
  ];
  text = builtins.readFile ./run.sh;
}
