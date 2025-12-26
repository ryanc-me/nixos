{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.apps.microsoft-teams;
in
{
  options.mine.home.apps.microsoft-teams = {
    enable = mkEnableOption "Enable Microsoft Teams (chat client)";
  };

  config = mkIf cfg.enable {
    #TODO: this
    #assert (osConfig.mine.nixos.apps.microsoft-edge = true): "Cannot enable (home) microsoft-outlook if (nixos) microsoft-edge is not active"

    xdg = {
      enable = true;

      dataFile."icons/hicolor/scalable/apps/microsoft-teams.svg".source = ./microsoft-teams.svg;
      desktopEntries.microsoft-teams = lib.mkForce {
        name = "Teams";
        comment = "Launch Microsoft Teams";
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
        icon = "microsoft-teams";
        exec = ''
          ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://teams.microsoft.com/v2/?clientType=pwa" %U
        '';
        settings = {
          StartupWMClass = "msedge-teams.microsoft.com__v2_-Default";
        };
      };
    };
  };
}
