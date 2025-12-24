{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.desktop.gnome;
in
{
  imports = [
    ./gdm-wallpaper
  ];

  options.mine.desktop.gnome = {
    enable = mkEnableOption "Enable GNOME desktop environment";
    monitors-xml = {
      enable = mkEnableOption "Enable custom monitors.xml for GDM";
      file = mkOption {
        type = lib.types.path;
        description = "Path to custom monitors.xml file for GDM";
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {

    systemd.tmpfiles.rules = mkIf (cfg.monitors-xml.enable && cfg.monitors-xml.file != null) [
      "L+ /var/lib/gdm/.config/monitors.xml - gdm gdm - ${cfg.monitors-xml.file}"
    ];

    # force Electron apps to use wayland instead of xwayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # enable gnome (with wayland + xwayland)
    services.displayManager.gdm.enable = true;
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

      # extensions
      #TODO: move these to home-manager?
      gnomeExtensions.blur-my-shell
      gnomeExtensions.just-perfection
      gnomeExtensions.caffeine
      gnomeExtensions.tailscale-qs
      gnomeExtensions.emoji-copy
      gnomeExtensions.iso-clock
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.color-picker
      gnomeExtensions.launch-new-instance
      gnomeExtensions.forge
      gnomeExtensions.status-area-horizontal-spacing
    ];

    # fonts
    fonts.packages = with pkgs; [
      # noto-fonts
      # noto-fonts-color-emoji
      # ttf-ubuntu-font-family
    ];

    # use firefox for various mime types
    xdg.mime.defaultApplications = mkIf config.mine.apps.firefox.enable  {
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
