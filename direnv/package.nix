{...} @ inputs: let
  project = import ./project.nix inputs;
in {
  inherit (project) util;
  inherit (project.root) build-shell find-watch-files generate-nix handle-stale-dependency-graph-nodes post;
}
