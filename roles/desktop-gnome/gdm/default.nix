{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop-gnome.gdm;
in
{
  options.mine.desktop-gnome.gdm = {
    enable = mkEnableOption "GDM display manager";
  };

  config = mkIf cfg.enable {
    services.displayManager.gdm.enable = true;
  };
}
