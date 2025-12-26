{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.home.apps.toggl-track;
in
{
  options.mine.home.apps.toggl-track = {
    enable = mkEnableOption "Enable Toggl Track (time tracking client)";
  };

  config = mkIf cfg.enable {
    #TODO: this
    #assert (osConfig.mine.nixos.apps.microsoft-edge = true): "Cannot enable (home) microsoft-outlook if (nixos) microsoft-edge is not active"

    xdg = {
      enable = true;

      dataFile."icons/hicolor/scalable/apps/toggl-track.svg".source = ./toggl-track.svg;
      desktopEntries.toggl-track = lib.mkForce {
        name = "Toggl Track";
        comment = "Launch Toggl Track";
        categories = [ "Utility" ];
        icon = "toggl-track";
        exec = ''
          ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://track.toggl.com/timer" %U
        '';
        settings = {
          StartupWMClass = "msedge-track.toggl.com__timer-Default";
        };
      };
    };
  };
}
