{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.core.system.network-firewall;
in
{
  options.mine.core.system.network-firewall = {
    enable = mkEnableOption "firewall (NixOS built-in)";
  };

  config = mkIf cfg.enable {
    # note: default implementation is iptables, which may be required
    # due to docker compatibility
    networking.firewall = {
      enable = true;

      # disable some noisy logging
      logRefusedConnections = false;
    };
  };
}
