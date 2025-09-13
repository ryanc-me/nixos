{ config, lib, pkgs, ... }:

let
  monitors-xml = ./monitors.xml;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  hardware.bluetooth.enable = true;
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
    hostName = "heibohre";
    networkmanager.enable = true;
  };

  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      luks.devices = {
        root = {
          device = "/dev/nvme0n1p2";
          preLVM = true;
        };
      };

      # required to get the keyboard working during boot for LUKS decryption
      # note that the order *is* important!
      availableKernelModules = [
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
    };

    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;
  };

  system.stateVersion = "25.05";
}
