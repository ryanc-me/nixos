{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.desktop-niri.system.niri;
in
{
  options.mine.desktop-niri.system.niri = {
    enable = mkEnableOption "niri support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      niri
      xwayland-satellite
      alacritty
      fuzzel
      nautilus

      gnome-keyring

      # cursor
      capitaine-cursors-themed
    ];

    programs.ssh.startAgent = true;

    # portals
    xdg.portal = {
      xdgOpenUsePortal = true;
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    # force Electron apps to use wayland instead of xwayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # add ~/.local/bin to PATH
    environment.localBinInPath = true;

    # use firefox for various mime types
    xdg.mime.defaultApplications = mkIf config.mine.desktop.apps.firefox.enable {
      "text/html" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
