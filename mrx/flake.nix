{
  description = "mrx";

  inputs = {
    nixpkgsSrc.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgsSrc, ...}: let
    mkMrxProjectWith = nixpkgs: {...} @ inputs: let
      importAttrsWith = inputs: let
        inherit (nixpkgs.lib) isAttrs;
        inherit (nixpkgs.lib.attrsets) mapAttrs;

        importAttrs = mapAttrs (_: value:
          if isAttrs value
          then importAttrs value
          else (import value inputs));
      in
        importAttrs;
      allInputs = inputs // {inherit importAttrsWith;};
      project = import ./project allInputs;
    in
      project;

    mapSystems = systems: let
      mkProject = system: let
        nixpkgs = import nixpkgsSrc {
          inherit system;
        };

        mkMrxProject = mkMrxProjectWith nixpkgs;

        project = mkMrxProject {
          inherit nixpkgs;
          pathSets = {
            infallible = import ./infallible.nix;
          };
        };
      in
        project;
    in
      builtins.listToAttrs ((builtins.map (
          system: let
            project = mkProject system;
          in {
            name = system;
            value = {
              inherit (project) shell;
              default = project.package;
            };
          }
        ))
        systems);
    systems = mapSystems ["aarch64-darwin" "x86_64-linux"];
  in
    {
      packages.aarch64-darwin = systems.aarch64-darwin;
      packages.x86_64-linux = systems.x86_64-linux;
    }
    // {inherit mkMrxProjectWith;};
}
