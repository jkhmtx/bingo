projectInputs: let
  inherit (projectInputs) pkgs;
  inherit (pkgs.lib) isAttrs;
  inherit (pkgs.lib.attrsets) mapAttrs;
  importAttrs = mapAttrs (_: value:
    if isAttrs value
    then importAttrs value
    else (import value projectInputs));
in let
  generated = import ./generated.nix;
in
  importAttrs generated
