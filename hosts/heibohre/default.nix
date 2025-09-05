{ config, lib, pkgs, ... }:

let
  monitors-xml = ./monitors.xml;
in
{
  imports = [
    ./hardware-configuration.nix
    ./kernel-modules.nix

    ../common/sops.nix
    ../common/users.nix
    ../common/features/electron-wayland.nix
    ../common/features/utils.nix
    ../common/features/1password.nix
    ../common/features/boot.nix
    ../common/features/sshd.nix
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
