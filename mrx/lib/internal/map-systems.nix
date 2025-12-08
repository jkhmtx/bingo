{
  nixpkgsSrc,
  pathAttrImports,
  ...
}: let
  mkProjectWith = import ./mk-project-with.nix;

  mapSystems = systems: let
    mkProject' = system: let
      nixpkgs = import nixpkgsSrc {
        inherit system;
      };

      project = (mkProjectWith nixpkgs) {
        inherit nixpkgs;

        inherit pathAttrImports;
      };
    in
      project;

    mapSystemAttrs = f:
      builtins.listToAttrs ((builtins.map (
          system: {
            name = system;
            value = f system;
          }
        ))
        systems);

    packages = mapSystemAttrs (
      system: let
        project = mkProject' system;
      in {
        inherit (project) shell;
        _ = project;
        default = project.package;
      }
    );

    apps = mapSystemAttrs (
      system: let
        mrx = {
          type = "app";
          program = "${packages."${system}".default}/bin/mrx";
        };
      in {
        inherit mrx;
        default = mrx;
      }
    );
  in {
    inherit apps packages;
  };
in
  mapSystems
