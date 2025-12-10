{
  description = "mrx";

  inputs = {
    nixpkgsSrc.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgsSrc, ...}: let
    pathAttrImports = {
      _ = import ./mrx.generated.nix;
      infallible = import ./infallible.nix;
    };

    mapSystems = import ./lib/internal/map-systems.nix {inherit nixpkgsSrc pathAttrImports;};
    mkProject = import ./lib/mk-project.nix pathAttrImports;

    systems = mapSystems ["aarch64-darwin" "x86_64-linux"];
  in {
    packages.aarch64-darwin = systems.packages.aarch64-darwin;
    packages.x86_64-linux = systems.packages.x86_64-linux;
    apps.aarch64-darwin = systems.apps.aarch64-darwin;
    apps.x86_64-linux = systems.apps.x86_64-linux;
    inherit mkProject;
  };
}
