{
  pkgs,
  projectNamespace,
  ...
}:
projectNamespace.root.util.with-tee {
  name = "direnv.lib.build-lazy-derivations";
  drv = pkgs.writeShellApplication {
    name = "direnv.lib.build-lazy-derivations.inner";

    runtimeInputs = [
      pkgs.coreutils
      pkgs.git
      projectNamespace.direnv.lib.build-and-symlink-derivations
      projectNamespace.direnv.lib.find-bins
    ];

    runtimeEnv = {
      BUILD_AND_SYMLINK = projectNamespace.direnv.lib.build-and-symlink-derivations.name;
      FIND_BINS = projectNamespace.direnv.lib.find-bins.name;
    };

    text = builtins.readFile ./run.sh;
  };
}
