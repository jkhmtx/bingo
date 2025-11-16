{pkgs, ...}:
pkgs.writeShellApplication {
  name = "frontend.yarn";
  runtimeInputs = [
    pkgs.yarn-berry
  ];
  text = builtins.readFile ./run.sh;
}
