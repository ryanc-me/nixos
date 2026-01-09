{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.mine.core.services.sshd;
in
{
  options.mine.core.services.sshd = {
    enable = mkEnableOption "OpenSSH server";
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
      allowSFTP = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers =
          [ ]
          ++ lib.optionals (config.mine.users.ryan.enable) [ "ryan" ]
          ++ lib.optionals (config.mine.users.angel.enable) [ "angel" ];
        AcceptEnv = [
          "LANG"
          "GIT_*"
        ];
      };
      extraConfig = ''
        AllowAgentForwarding yes
      '';
    };
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openPorts [ cfg.port ];
  };
}
