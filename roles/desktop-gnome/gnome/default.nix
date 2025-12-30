{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop-gnome.gnome;
in
{
  options.mine.desktop-gnome.gnome = {
    enable = mkEnableOption "GNOME desktop environment";
  };

  config = mkIf cfg.enable {
    # force Electron apps to use wayland instead of xwayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # enable gnome (with wayland + xwayland)
    services.desktopManager.gnome.enable = true;

    # portals
    xdg.portal = {
      xdgOpenUsePortal = true;
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    environment.systemPackages = with pkgs; [
      # cursor
      pkgs.capitaine-cursors-themed

      # other
      gnome-tweaks
      refine
    ];

    # use firefox for various mime types
    xdg.mime.defaultApplications = mkIf config.mine.desktop.apps.firefox.enable {
      "text/html" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };

    # dconf
    programs.dconf.profiles.gdm.databases = [
      {
        settings."org/gnome/mutter" = {
          experimental-features = [ "scale-monitor-framebuffer" ];
        };
        settings."org/gnome/desktop/interface" = {
          cursor-theme = "Capitaine Cursors";
          cursor-size = lib.gvariant.mkInt32 24;
        };
      }
    ];
  };
}
