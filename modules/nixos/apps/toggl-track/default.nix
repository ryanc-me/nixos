{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.apps.toggl-track;
in
{
  options.mine.apps.toggl-track = {
    enable = mkEnableOption "Enable Toggl Track (time tracking client)";
  };

  config = mkIf cfg.enable {
    #TODO: move to modules/home/
    # # just below direct-setting, but above mkForce to allow user override
    # mine.apps.toggl-track.enable = lib.mkOverride 90 true;

    # xdg = {
    #   enable = true;

    #   dataFile."icons/hicolor/scalable/apps/toggl-track.svg".source = ./icons/toggl-track.svg;
    #   desktopEntries.toggl-track = lib.mkForce {
    #     name = "Toggl Track";
    #     comment = "Launch Toggl Track";
    #     categories = [ "Utility" ];
    #     icon = "toggl-track";
    #     exec = ''
    #       ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://track.toggl.com/timer" %U
    #     '';
    #     settings = {
    #       StartupWMClass = "msedge-track.toggl.com__timer-Default";
    #     };
    #   };
    # };
  };
}
