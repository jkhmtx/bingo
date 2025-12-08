{pkgs, ...}:
# No-op
pkgs.writeShellApplication {
  name = "root.package";
  text = "true";
}
