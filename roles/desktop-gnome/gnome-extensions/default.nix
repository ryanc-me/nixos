{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop-gnome.gnome-extensions;
in
{
  options.mine.desktop-gnome.gnome-extensions = {
    enable = mkEnableOption "GNOME extensions management";
    extensions = mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of GNOME extensions to enable";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = (map (pkg: pkgs.gnomeExtensions.${pkg}) cfg.extensions);
  };
}
