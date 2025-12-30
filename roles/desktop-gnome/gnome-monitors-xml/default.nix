{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop-gnome.gnome-monitors-xml;
in
{
  options.mine.desktop-gnome.gnome-monitors-xml = {
    enable = mkEnableOption "GNOME monitors.xml management";
    source = mkOption {
      type = lib.types.path;
      description = "Path to custom monitors.xml file for GDM";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = mkIf (cfg.source != null) [
      "L+ /var/lib/gdm/.config/monitors.xml - gdm gdm - ${cfg.source}"
    ];
  };
}
