{nixpkgs, ...} @ inputs: let
  inherit (nixpkgs.lib) isAttrs;
  inherit (nixpkgs.lib.attrsets) mapAttrs;
  importAttrs = mapAttrs (_: value:
    if isAttrs value
    then importAttrs value
    else (import value inputs));
in
  importAttrs
