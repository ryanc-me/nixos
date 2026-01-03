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
    ../../roles
  ];

  mine = {
    desktop-gnome.gnome-monitors-xml.source = monitors-xml;
    desktop.services.display = {
      screenW = 3840;
      screenH = 2160;
      screenScale = 1.25;
    };
    desktop.system = {
      gpu-nvidia.enable = true;
    };
    users.angel.enable = true;

    # enable some gaming sysctls + Xanmod kernel
    desktop-gaming.system.sysctl.enable = true;
    core.system.kernel.package = pkgs.linuxPackages_xanmod_latest;

    # enable roles
    core.enable = true;
    desktop.enable = true;
    desktop-gaming.enable = true;
    desktop-gnome.enable = true;
    desktop-vms.enable = true;
    monitoring.enable = true;
    monitoring-server.enable = true;
    users.enable = true;
  };

  # blacklist motherboard bluetooth (13d3:3533) because it was crap, and was
  # preventing my bluetooth USB dongle from working
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="13d3", ATTR{idProduct}=="3533", ATTR{authorized}="0"
  '';

  system.stateVersion = "25.05";
}
