{...} @ inputs: let
  nixpkgs =
    inputs.nixpkgs or inputs.pkgs or (let
      nixpkgsSrc = import ./nix/nixpkgs.nix;
    in
      import nixpkgsSrc {config = {};});

  importAttrs = import ./nix/util/import-attrs.nix {
    inherit nixpkgs infallible;
    _ = root;
  };

  drvs = {
    root = import ./nix/root.nix {};
    infallible = import ./nix/infallible.nix {};
  };

  root = importAttrs drvs.root;
  infallible = importAttrs drvs.infallible;
in
  {
    util = {
      inherit importAttrs;
    };
  }
  // root // infallible
