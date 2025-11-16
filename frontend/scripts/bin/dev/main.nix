{pkgs, ...}:
pkgs.writeShellApplication {
  name = "frontend.dev";
  runtimeInputs = [
    pkgs.git
    pkgs.yarn-berry
  ];
  text = builtins.readFile ./run.sh;
}
