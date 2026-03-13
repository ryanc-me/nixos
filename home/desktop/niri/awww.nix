{
  config,
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  niriEnabled = osConfig.mine ? desktop-niri && osConfig.mine.desktop-niri.enable;
  awwwPkg = inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;

  awww = "${awwwPkg}/bin/awww";
  awwwDaemon = "${awwwPkg}/bin/awww-daemon";

  plainWallpaper = osConfig.mine.desktop.system.wallpaper.processed.plain.zoom;

  blurredWallpaper = osConfig.mine.desktop.system.wallpaper.processed.blurred.zoom;
in
{
  config = mkIf (niriEnabled) {
    home.packages = with pkgs; [
      awwwPkg
    ];
    systemd.user.services = {
      awww-wallpaper = {
        Unit = {
          Description = "awww daemon for desktop wallpaper";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          Requisite = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${awwwDaemon} --namespace wallpaper";
          Restart = "on-failure";
          RestartSec = 1;
        };

        Install = {
          WantedBy = [ "niri.service" ];
        };
      };

      awww-overview = {
        Unit = {
          Description = "awww daemon for niri overview backdrop";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
          Requisite = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${awwwDaemon} --namespace overview";
          Restart = "on-failure";
          RestartSec = 1;
        };

        Install = {
          WantedBy = [ "niri.service" ];
        };
      };

      awww-wallpaper-apply = {
        Unit = {
          Description = "Apply desktop wallpaper via awww";
          After = [ "awww-wallpaper.service" ];
          Requires = [ "awww-wallpaper.service" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = ''
            ${awww} img --transition-type none --namespace wallpaper ${lib.escapeShellArg plainWallpaper}/share/wallpapers/plain.png
          '';
        };

        Install = {
          WantedBy = [ "niri.service" ];
        };
      };

      awww-overview-apply = {
        Unit = {
          Description = "Apply overview backdrop via awww";
          After = [ "awww-overview.service" ];
          Requires = [ "awww-overview.service" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = ''
            ${awww} img --transition-type none --namespace overview ${lib.escapeShellArg blurredWallpaper}/share/wallpapers/blurred.png
          '';
        };

        Install = {
          WantedBy = [ "niri.service" ];
        };
      };
    };
  };
}
