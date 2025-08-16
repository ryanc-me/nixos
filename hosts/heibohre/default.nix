{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./kernel-modules.nix

    ../common/sops.nix
    ../common/users.nix
    ../common/features/electron-wayland.nix
    ../common/features/utils.nix
    ../common/features/1password.nix
    ../common/desktop/gnome.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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


  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "heibohre";
  networking.wireless.enable = true;
  networking.networkmanager.enable = false;

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  system.stateVersion = "25.05";
}
