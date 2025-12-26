{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.apps.spotify;
in
{
  options.mine.home.apps.spotify = {
    enable = mkEnableOption "spotify";
  };

  config = mkIf (config.mine.home.services.flatpak.enable && cfg.enable) {
    services.flatpak = {
      packages = [
        "flathub:app/com.spotify.Client//stable"
      ];
    };
  };
}
