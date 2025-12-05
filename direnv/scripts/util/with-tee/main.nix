{nixpkgs, ...}: {
  name,
  drv,
  teeFilePrefix ? null,
}:
nixpkgs.writeShellApplication {
  inherit name;

  runtimeInputs = [
    nixpkgs.coreutils
    drv
  ];

  runtimeEnv =
    {
      DRV_NAME = drv.name;
    }
    // (
      if teeFilePrefix == null
      then {}
      else {
        TEE_FILE_PREFIX = teeFilePrefix;
      }
    );

  text = builtins.readFile ./run.sh;
}
