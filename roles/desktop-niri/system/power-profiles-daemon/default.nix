{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-niri.system.power-profiles-daemon;
in
{
  options.mine.desktop-niri.system.power-profiles-daemon = {
    enable = mkEnableOption "power-profiles-daemon support";
  };

  config = mkIf cfg.enable {
    services.power-profiles-daemon = {
      enable = true;
    };
  };
}
