{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-niri.system.upower;
in
{
  options.mine.desktop-niri.system.upower = {
    enable = mkEnableOption "upower support";
  };

  config = mkIf cfg.enable {
    services.upower = {
      enable = true;
    };
  };
}
