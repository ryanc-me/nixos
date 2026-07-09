{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-niri.system.playerctl;
in
{
  options.mine.desktop-niri.system.playerctl = {
    enable = mkEnableOption "playerctl support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      playerctl
    ];
  };
}
