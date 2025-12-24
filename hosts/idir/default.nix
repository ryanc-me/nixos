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
      screenW = 3840;
      screenH = 2160;
      screenScale = 1.25;
    };
    system = {
      gpu.nvidia.enable = true;
      networking.hostname = {
        enable = true;
        hostname = "idir";
      };
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  system.stateVersion = "25.05";
}
