{
  description = "mrx";

  inputs = {
    nixpkgsSrc.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgsSrc, ...}: let
    mapSystems = systems: let
      mkOutput = system: let
        nixpkgs = import nixpkgsSrc {
          inherit system;
        };

        inherit (import ./include {inherit nixpkgs;}) project;
      in {
        default = project.package;

        inherit (project) shell util;
        inherit system;
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
