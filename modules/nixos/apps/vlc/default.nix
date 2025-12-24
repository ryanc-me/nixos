{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.vlc;
in
{
  options.mine.apps.vlc = {
    enable = mkEnableOption "Enable VLC (media player)";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vlc
    ];
  };
}
