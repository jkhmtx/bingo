{
  nixpkgs,
  infallible,
  ...
}:
infallible.with-tee {
  name = "root.lib.find-generated-nix-raw-attrset";
  drv = nixpkgs.writeShellApplication {
    name = "root.lib.find-generated-nix-raw-attrset.inner";

    runtimeInputs = [
      nixpkgs.git
    ];

    text = builtins.readFile ./run.sh;
  };
}
