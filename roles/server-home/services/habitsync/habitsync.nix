{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  cfg = config.services.habitsync;
  isCustomDataDir = cfg.dataDir != "/var/lib/habitsync";
in
{
  options = {
    services.habitsync = {
      enable = lib.mkEnableOption "habitsync, archive extraction daemon";

      environmentFile = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = "Location of habitsync's environment file.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open a port in the firewall for the Overseerr web interface.";
      };

      package = lib.mkPackageOption self.packages.${pkgs.stdenv.hostPlatform.system} "habitsync" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      services.habitsync = {
        description = "habitsync - archive extraction daemon";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = "habitsync";
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          ExecStart = "${lib.getExe cfg.package}";
          Restart = "on-failure";
        };
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 6842 ];
    };
  };
}