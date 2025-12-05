{
  nixpkgs,
  _,
  ...
}:
nixpkgs.writeShellApplication {
  name = "root.lib.generate-ignore-patterns-file";
  runtimeInputs = [
    nixpkgs.coreutils
    nixpkgs.gnused
    _.root.lib.get-config-value
  ];

  runtimeEnv = {
    GET_CONFIG_VALUE = _.root.lib.get-config-value.name;
  };
  text = builtins.readFile ./run.sh;
}
