{
  description = "root";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
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

        projectInputs = {
          inherit package;
          inherit pkgs;
          projectNamespace = import ./nix/project.nix projectInputs;
        };

        shell = import ./nix/dev-shell.nix projectInputs;
      in
        {
          inherit package shell system;
          default = package;
        }
        // projectInputs.projectNamespace;

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
