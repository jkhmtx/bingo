{
  nixpkgs,
  _,
  ...
}:
nixpkgs.writeShellApplication {
  name = "root.hook";
  runtimeInputs = [
    nixpkgs.coreutils
    nixpkgs.findutils
    nixpkgs.gnused
    _.root.lib.find-bins
  ];

  runtimeEnv = {
    FIND_BINS = _.root.lib.find-bins.name;
  };
  text = builtins.readFile ./run.sh;
}
