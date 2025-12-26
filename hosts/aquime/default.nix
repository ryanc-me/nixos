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
    ../../roles/desktop.nix
  ];

  mine.nixos = {
    desktop.gnome.monitors-xml = monitors-xml;
    desktop.display = {
      screenW = 1920;
      screenH = 1200;
      screenScale = 1.25;
    };
    desktop.wallpaper.mode = "zoom";
    services.fprintd.enable = true;
  };

  system.stateVersion = "25.05";
}
