{
  description = "root";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    mrxSrc.url = "path:mrx";
    mrxSrc.inputs.nixpkgsSrc.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    mrxSrc,
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

        package = import ./nix/package.nix projectInputs;
        mrx = mrxSrc.packages."${system}".default;

        _ = import ./nix/project.nix projectInputs;

        projectInputs = {
          inherit package;
          inherit pkgs;
          inherit mrx;
          inherit _;
        };

        shell = import ./nix/shell.nix projectInputs;
      in {
        inherit _ package shell system mrx;
        default = package;
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
