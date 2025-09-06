{ config, pkgs, lib, ... }:

{

  home.packages = with pkgs; [
    microsoft-edge
  ];

  xdg = {
    enable = true;

    # ms teams
    dataFile."icons/hicolor/scalable/apps/microsoft-teams.svg".source = ./icons/microsoft-teams.svg;
    desktopEntries.microsoft-teams = lib.mkForce {
      name = "Teams";
      comment = "Launch Microsoft Teams";
      categories = [ "Network" "InstantMessaging" "Chat" ];
      icon = "microsoft-teams";
      exec = ''
        ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://teams.microsoft.com/v2/?clientType=pwa" %U
      '';
      settings = {
        StartupWMClass = "msedge-teams.microsoft.com__v2_-Default";
      };
    };

    # ms outlook
    dataFile."icons/hicolor/scalable/apps/microsoft-outlook.svg".source = ./icons/microsoft-outlook.svg;
    desktopEntries.microsoft-outlook = lib.mkForce {
      name = "Outlook";
      comment = "Launch Microsoft Outlook";
      categories = [ "Network" "Email" ];
      icon = "microsoft-outlook";
      exec = ''
        ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://outlook.office.com/mail/" %U
      '';
      settings = {
        StartupWMClass = "msedge-outlook.office.com__mail_-Default";
      };
    };

    # toggl track
    dataFile."icons/hicolor/scalable/apps/toggl-track.svg".source = ./icons/toggl-track.svg;
    desktopEntries.toggl-track = lib.mkForce {
      name = "Toggl Track";
      comment = "Launch Toggl Track";
      categories = [ "Utility" ];
      icon = "toggl-track";
      exec = ''
        ${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform,WebUIDarkMode --ozone-platform-hint=wayland --force-dark-mode --app="https://track.toggl.com/timer" %U
      '';
      settings = {
        StartupWMClass = "msedge-track.toggl.com__timer_-Default";
      };
    };
  };
}
