{
  description = "root";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    mrx.url = "path:mrx";
    mrx.inputs.nixpkgsSrc.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    mrx,
    ...
  }: let
    mapSystems = systems: let
      mkOutput = system: let
        pkgs = import nixpkgs {
          inherit system;

          config.packageOverrides = pkgs: {
            imagemagickBig = pkgs.imagemagick.override {
              libpngSupport = true;
            };
          };
        };

        _ = mrx.mkProject {
          inherit pkgs;
          inherit (_) mrx;

          pathAttrImports = {
            _ = import ./mrx.generated.nix;
          };
        };
      in {
        inherit system;
        inherit (_) mrx package shell;
        default = _.package;
      };

      outputs = (builtins.map mkOutput) systems;
    in
      builtins.listToAttrs ((builtins.map (
          output: {
            name = output.system;
            value = output;
          }
        ))
        outputs);
    systems = mapSystems ["aarch64-darwin" "x86_64-linux"];
  in {
    packages.aarch64-darwin = systems.aarch64-darwin;
    packages.x86_64-linux = systems.x86_64-linux;
  };
}
