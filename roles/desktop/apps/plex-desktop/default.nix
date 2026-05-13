{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop.apps.plex-desktop;
in
{
  options.mine.desktop.apps.plex-desktop = {
    enable = mkEnableOption "plex-desktop";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      plex-desktop
    ];
  };
}
