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
    ../../modules/nixos/import.nix
    ../../roles/desktop.nix
  ];

  # device-specific
  mine = {
    desktop.gnome.monitors-xml = {
      enable = true;
      file = monitors-xml;
    };
    desktop.display = {
      screenW = 1920;
      screenH = 1200;
      screenScale = 1.25;
    };
    desktop.wallpaper.mode = "zoom";
    services.fprintd = true;
    system.networking.hostname = {
      enable = true;
      hostname = "aquime";
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  system.stateVersion = "25.05";
}
