{pkgs, ...}:
pkgs.writeShellApplication {
  name = "frontend.preview";
  runtimeInputs = [
    pkgs.git
    pkgs.yarn-berry
  ];
  text = builtins.readFile ./run.sh;
}
