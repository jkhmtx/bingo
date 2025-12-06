{nixpkgs, ...}: let
  inputs = {
    inherit nixpkgs;
    _ = project;
  };

  project = import ./project.nix inputs;
in {
  inherit project inputs;
}
