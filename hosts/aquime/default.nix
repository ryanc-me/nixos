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

    # roles
    ../../roles/core
    ../../roles/desktop
    ../../roles/desktop-gaming
    ../../roles/desktop-gnome
    ../../roles/desktop-vms
    ../../roles/monitoring
    ../../roles/monitoring-server
    ../../roles/users
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
  };

  system.stateVersion = "25.05";
}
