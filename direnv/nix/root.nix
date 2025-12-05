{...}: {
  root.lib.get-config-value = ../scripts/lib/get-config-value/main.nix;
  root.build-shell = ../scripts/bin/build-shell/main.nix;
  root.find-watch-files = ../scripts/bin/find-watch-files/main.nix;
  root.generate-nix = ../scripts/bin/generate-nix/main.nix;
  root.generate = ../scripts/bin/generate/main.nix;
  root.handle-stale-dependency-graph-nodes = ../scripts/bin/handle-stale-dependency-graph-nodes/main.nix;
  root.post = ../scripts/bin/post/main.nix;
  root.lib.build-and-symlink-derivations = ../scripts/lib/build-and-symlink-derivations/main.nix;
  root.lib.find-bins = ../scripts/lib/find-bins/main.nix;
  root.lib.find-dependency-graph-edges = ../scripts/lib/find-dependency-graph-edges/main.nix;
  root.lib.find-generated-nix-raw-attrset = ../scripts/lib/find-generated-nix-raw-attrset/main.nix;
  root.lib.mtime-database = ../scripts/lib/mtime-database/main.nix;
  root.util.with-tee = ../scripts/util/with-tee/main.nix;
}
