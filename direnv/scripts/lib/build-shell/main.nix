{
  pkgs,
  projectNamespace,
  ...
}:
projectNamespace.root.util.with-tee {
  name = "direnv.lib.build-shell";
  drv = pkgs.writeShellApplication {
    name = "direnv.lib.build-shell.inner";

    text = builtins.readFile ./run.sh;
  };
}
