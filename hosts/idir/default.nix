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

  mine.nixos = {
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

  # blacklist motherboard bluetooth (13d3:3533) because it was crap, and was
  # preventing my bluetooth USB dongle from working
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3533", ATTR{authorized}="0"
  '';

  system.stateVersion = "25.05";
}
