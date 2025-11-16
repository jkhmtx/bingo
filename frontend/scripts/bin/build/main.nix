{pkgs, ...}:
pkgs.writeShellApplication {
  name = "frontend.build";
  runtimeInputs = [
    pkgs.git
    pkgs.yarn-berry
  ];
  text = builtins.readFile ./run.sh;
}
