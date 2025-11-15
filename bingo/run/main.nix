{pkgs, ...}:
pkgs.writeShellApplication {
  name = "bingo.run";
  runtimeInputs = [
    pkgs.bc
    pkgs.git
    pkgs.ghostscript
    pkgs.imagemagickBig
    pkgs.viewnior
  ];

  runtimeEnv = {
    TEST_ENV = ./test.env;
  };
  text = builtins.readFile ./run.sh;
}
