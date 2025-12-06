{nixpkgs, ...} @ inputs: let
  inherit (nixpkgs.lib) isAttrs;
  inherit (nixpkgs.lib.attrsets) mapAttrs;

  importAttrs = mapAttrs (_: value:
    if isAttrs value
    then importAttrs value
    else (import value (inputs // infallible)));

  drvs = {
    generated = import ./generated.nix {};
    infallible = import ./infallible.nix {};
  };

  generated = importAttrs drvs.generated;
  infallible = importAttrs drvs.infallible;
in
  generated
  // {
    inherit infallible;
    util = {inherit importAttrs;};
  }
