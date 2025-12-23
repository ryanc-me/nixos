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
    ./fingerprint-reader.nix

    ../../modules/nixos
  ];

  # device-specific
  my = {
    screenW = 1920;
    screenH = 1200;
    screenScale = 1.25;
    wallpaper = {
      enable = true;
      path = ../../assets/wallpapers/wallhaven-o5g125.jpg;
      mode = "zoom";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  time.timeZone = "Pacific/Auckland";

  # for GDM
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - gdm gdm - ${monitors-xml}"
  ];

  networking = {
    hostName = "aquime";
    networkmanager.enable = true;
  };

  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  system.stateVersion = "25.05";
}
