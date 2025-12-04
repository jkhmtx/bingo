{
  pkgs,
  projectNamespace,
  ...
}:
projectNamespace.root.util.with-tee {
  name = "direnv.lib.watch-files";
  drv = pkgs.writeShellApplication {
    name = "direnv.lib.watch-files.inner";

    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
    ];

    text = builtins.readFile ./run.sh;
  };
}
