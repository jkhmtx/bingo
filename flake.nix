{
  description = "root";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;

          config.packageOverrides = pkgs: {
            imagemagickBig = pkgs.imagemagick.override {
              libpngSupport = true;
            };
          };
        };
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.imagemagickBig
              pkgs.mprocs
            ];
          };
        };
      }
    );
}
