{ config, pkgs, ... }:

{
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
    # extensions
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

    # cursor
    capitaine-cursors-themed

    # other
    gnome-tweaks

    # portals
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  # fonts
  fonts.packages = with pkgs; [];
}
