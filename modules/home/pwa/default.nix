{
  config,
  pkgs,
  lib,
  ...
}:

{

  # home.packages = with pkgs; [
  #   microsoft-edge
  # ];

  # xdg = {
  #   enable = true;

  #   # ms teams

  #   # ms outlook

  #   # toggl track
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
}
