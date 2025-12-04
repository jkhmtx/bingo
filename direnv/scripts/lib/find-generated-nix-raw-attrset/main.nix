{
  pkgs,
  infallible,
  ...
}:
infallible.with-tee {
  name = "direnv.lib.find-generated-nix-raw-attrset";
  drv = pkgs.writeShellApplication {
    name = "direnv.lib.find-generated-nix-raw-attrset.inner";

    runtimeInputs = [
      pkgs.git
    ];

    text = builtins.readFile ./run.sh;
  };
}
