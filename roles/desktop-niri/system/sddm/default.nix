{
  config,
  pkgs,
  lib,
  inputs,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-niri.system.sddm;
  wp =
    config.mine.desktop.system.wallpaper.processed.plain.${config.mine.desktop.system.wallpaper.mode};
in
{
  options.mine.desktop-niri.system.sddm = {
    enable = mkEnableOption "sddm support";
  };

  config = mkIf cfg.enable {
    programs.silentSDDM = {
      enable = true;
      theme = "default";
      backgrounds = {
        default = "${wp}/share/wallpapers/plain.png";
      };
      settings = {
        "LoginScreen" = {
          background = "plain.png";
        };
        "LockScreen" = {
          background = "plain.png";
        };
      };
    };
    services.displayManager = {
      defaultSession = "niri";
      sessionPackages = [
        pkgs.niri
      ];
      sddm = {
        enable = true;
        wayland.enable = true;
        extraPackages = [
          pkgs.capitaine-cursors-themed
        ];
        settings = {
          Theme = {
            CursorTheme = "capitaine-cursors";
            CursorSize = 32;
          };

          General = {
            GreeterEnvironment = lib.mkForce (
              # from the silentSDDM package
              "QML2_IMPORT_PATH=${config.programs.silentSDDM.package'}/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard"
              # custom
              + ",XCURSOR_THEME=capitaine-cursors,XCURSOR_SIZE=32,QT_SCALE_FACTOR=1.25,QT_FONT_DPI=144"
            );
          };
        };
      };
    };
  };
}
