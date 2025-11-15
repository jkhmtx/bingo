{
  description = "root";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";

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

    devShell = import ./nix/dev-shell.nix projectInputs;
  in
    {
      inherit devShell;
      packages."${system}".default = package;
    }
    // projectInputs.projectNamespace;
}
