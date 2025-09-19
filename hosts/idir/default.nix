{
  config,
  lib,
  pkgs,
  ...
}:

let
  monitors-xml = ./monitors.xml;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # device-specific
  my = {
    screenW = 3840;
    screenH = 2160;
    screenScale = 1.25;
    wallpaper = {
      enable = true;
      path = ../../wallpapers/wallhaven-wyrqg7.png;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "idir";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

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

  # for GDM
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - gdm gdm - ${monitors-xml}"
  ];

  hardware.bluetooth.enable = true;

  system.stateVersion = "25.05";
}
