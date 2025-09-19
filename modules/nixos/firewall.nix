{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # syncthing
      22000
    ];
    allowedUDPPorts = [
      # syncthing
      22000
    ];
  };
}
