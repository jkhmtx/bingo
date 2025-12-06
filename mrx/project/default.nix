{
  importAttrsWith,
  nixpkgs,
  ...
} @ moduleInputs: let
  inputs =
    moduleInputs
    // {
      _ = project;
    };

  pathSets =
    if moduleInputs ? pathSets
    then let
      inherit (nixpkgs.lib.attrsets) mapAttrs;
      importAttrs = importAttrsWith (moduleInputs // pathSets);
    in
      mapAttrs (_: attrs: importAttrs attrs) moduleInputs.pathSets
    else {};

  importAttrs = importAttrsWith (inputs // pathSets);

  generated = import ./generated.nix;
  project = importAttrs generated;
in
  project
