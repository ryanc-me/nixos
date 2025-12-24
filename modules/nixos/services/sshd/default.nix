{ config, pkgs, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.services.sshd;
in
{
  options.mine.services.sshd = {
    enable = mkEnableOption "Enable SSHD (OpenSSH server)";
    port = mkOption {
      type = lib.types.port;
      default = 22;
      description = "Port for SSHD to listen on";
    };
    openPorts = mkEnableOption "Open the SSHD port in the firewall";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      settings = {
        PasswordAuthentication = true;
        PermitRootLogin = "no";
      };
    };
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openPorts [ cfg.port ];
  };
}
