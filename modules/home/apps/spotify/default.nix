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

  config = mkIf cfg.enable {
    xdg = {
      enable = true;

      dataFile."icons/hicolor/scalable/apps/spotify.svg".source = ./spotify.svg;
      desktopEntries.spotify = lib.mkForce {
        name = "Spotify";
        comment = "Launch Spotify";
        categories = [
          "Audio"
        ];
        icon = "spotify";
        exec = ''
          ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://open.spotify.com" %U
        '';
        settings = {
          StartupWMClass = "open.spotify.com";
        };
      };
    };

  };
}
