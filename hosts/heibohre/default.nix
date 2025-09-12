{ config, lib, pkgs, ... }:

let
  monitors-xml = ./monitors.xml;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # device-specific
  my = {
    screenW = 2256;
    screenH = 1504;
    screenScale = 1.5;
    wallpaper = {
      enable = true;
      path = ../../wallpapers/wallhaven-wyrqg7.png;
      mode = "centered";
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Data disk & swap are encrypted with LUKS
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # required to get the keyboard working during boot for LUKS decryption
  # note that the order *is* important!
  boot.initrd.availableKernelModules = [
    "pinctrl_icelake"
    "surface_aggregator"
    "surface_aggregator_registry"
    "surface_aggregator_hub"
    "surface_hid_core"
    "8250_dw"
    "surface_hid"
    "intel_lpss"
    "intel_lpss_pci"
  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "heibohre";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  programs.dconf.profiles.gdm.databases = [{
    settings."org/gnome/mutter" = {
      experimental-features = ["scale-monitor-framebuffer"];
    };
    settings."org/gnome/desktop/interface" = {
      cursor-theme = "Capitaine Cursors";
      cursor-size = lib.gvariant.mkInt32 24;
    };
  }];

  # for GDM
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - gdm gdm - ${monitors-xml}"
  ];

  hardware.bluetooth.enable = true;

  system.stateVersion = "25.05";
}
