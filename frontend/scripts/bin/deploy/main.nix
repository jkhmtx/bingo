{pkgs, ...}:
pkgs.writeShellApplication {
  name = "frontend.deploy";
  runtimeInputs = [
    pkgs.git
    pkgs.wrangler
    pkgs.yarn-berry
  ];

  runtimeEnv = {
    DIST = "./dist";
  };

  text = builtins.readFile ./run.sh;
}
