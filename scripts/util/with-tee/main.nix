{pkgs, ...}: {
  name,
  drv,
  teeFilePrefix ? null,
}:
pkgs.writeShellApplication {
  inherit name;

  runtimeInputs = [
    pkgs.coreutils
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
