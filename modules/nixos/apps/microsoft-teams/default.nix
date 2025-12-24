{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.microsoft-teams;
in
{
  options.mine.apps.microsoft-teams = {
    enable = mkEnableOption "Enable Microsoft Teams (chat client)";
  };

  config = mkIf cfg.enable {
    #TODO: move to modules/home/
    # # just below direct-setting, but above mkForce to allow user override
    # mine.apps.microsoft-teams.enable = lib.mkOverride 90 true;

    # xdg = {
    #   enable = true;

    #   dataFile."icons/hicolor/scalable/apps/microsoft-teams.svg".source = ./icons/microsoft-teams.svg;
    #   desktopEntries.microsoft-teams = lib.mkForce {
    #     name = "Teams";
    #     comment = "Launch Microsoft Teams";
    #     categories = [
    #       "Network"
    #       "InstantMessaging"
    #       "Chat"
    #     ];
    #     icon = "microsoft-teams";
    #     exec = ''
    #       ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://teams.microsoft.com/v2/?clientType=pwa" %U
    #     '';
    #     settings = {
    #       StartupWMClass = "msedge-teams.microsoft.com__v2_-Default";
    #     };
    #   };
    # };
  };
}
