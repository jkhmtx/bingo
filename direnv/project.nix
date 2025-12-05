{...} @ inputs: let
  nixpkgs =
    inputs.nixpkgs or inputs.pkgs or (let
      nixpkgsSrc = import ./nix/nixpkgs.nix;
    in
      import nixpkgsSrc {config = {};});

  importAttrs = import ./nix/util/import-attrs.nix {
    inherit nixpkgs infallible;
    _ = generated;
  };

  drvs = {
    generated = import ./nix/generated.nix {};
    infallible = import ./nix/infallible.nix {};
  };

  generated = importAttrs drvs.generated;
  infallible = importAttrs drvs.infallible;
in
  {
    util = {
      inherit importAttrs;
    };
  }
  // generated // infallible
