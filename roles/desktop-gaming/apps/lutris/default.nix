{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-gaming.apps.lutris;
in
{
  options.mine.desktop-gaming.apps.lutris = {
    enable = mkEnableOption "lutris (game platform)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
