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
    inputs.nixos-hardware.nixosModules.gigabyte-b550

    # roles
    ../../roles/desktop.nix
  ];

  mine = {
    desktop.gnome.monitors-xml = monitors-xml;
    desktop.display = {
      screenW = 3840;
      screenH = 2160;
      screenScale = 1.25;
    };
    system = {
      gpu.nvidia.enable = true;
    };
  };

  system.stateVersion = "25.05";
}
