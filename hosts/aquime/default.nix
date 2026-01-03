{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  monitors-xml = ./monitors.xml;
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen5
    ../../roles
  ];

  mine = {
    desktop-gnome.monitors-xml.source = monitors-xml;
    desktop.services.display = {
      screenW = 1920;
      screenH = 1200;
      screenScale = 1.25;
    };
    desktop.system.wallpaper.mode = "zoom";
    desktop.services.fprintd.enable = true;
    users.angel.enable = true;

    # enable roles
    core.enable = true;
    desktop.enable = true;
    desktop-gnome.enable = true;
    desktop-gaming.enable = true;
    desktop-vms.enable = true;
    monitoring.enable = true;
    monitoring-server.enable = true;
    users.enable = true;
  };

  system.stateVersion = "25.05";
}
