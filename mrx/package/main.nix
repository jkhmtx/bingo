{
  nixpkgs,
  _,
  ...
}: let
  rustPlatform = nixpkgs.makeRustPlatform {
    cargo = _.rust;
    rustc = _.rust;
  };

  crateSrc = crate: ["crates/${crate}" "crates/${crate}/src"];

  package = rustPlatform.buildRustPackage {
    pname = "mrx";
    version = "0.0.1";

    src = nixpkgs.lib.sourceByRegex ../. (
      ["crates"]
      ++ (crateSrc "mrx-hook")
      ++ (crateSrc "mrx-bin")
      ++ (crateSrc "mrx-utils")
      ++ [".+\.rs" "^Cargo\.lock$" ".*Cargo\.toml"]
    );

    cargoHash = "sha256-5Ji8QdNQyGK8gEXTHEantRmaSneSu1xWNdm2bI+oxDM=";

    meta = {
      mainProgram = "mrx";
      description = "A Nix DevOps framework for monorepos";
      homepage = "https://github.com/jkhmtx/bingo";
      license = nixpkgs.lib.licenses.unlicense;
      maintainers = ["jakehamtexas@gmail.com"];
    };
  };
in
  nixpkgs.writeShellApplication {
    name = "mrx";
    runtimeInputs = [
      _.root.build-shell
      _.root.find-watch-files
      _.root.generate-nix
      _.root.handle-stale-dependency-graph-nodes
      _.root.lib.build-and-symlink-derivations
      _.root.hook
      package
    ];

    runtimeEnv = {
      BUILD_AND_SYMLINK = _.root.lib.build-and-symlink-derivations.name;
      BUILD_SHELL = _.root.build-shell.name;
      FIND_WATCH_FILES = _.root.find-watch-files.name;
      GENERATE_NIX = _.root.generate-nix.name;
      HANDLE_STALE_DEPENDENCY_GRAPH_NODES = _.root.handle-stale-dependency-graph-nodes.name;
      HOOK = _.root.hook.name;
      #######
      PACKAGE = package.pname;
    };
    text = builtins.readFile ./run.sh;
  }
