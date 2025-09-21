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
    ./nvidia-gpu.nix

    ../../modules/nixos
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  time.timeZone = "Pacific/Auckland";

  #TODO: move this somewhere else?
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  # for GDM
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - gdm gdm - ${monitors-xml}"
  ];

  networking = {
    hostName = "idir";
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
