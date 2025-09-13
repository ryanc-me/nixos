{ config, pkgs, ... }:

{
  imports = [
    ./gdm-wallpaper.nix
    ./gnome-extensions.nix
  ];

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
