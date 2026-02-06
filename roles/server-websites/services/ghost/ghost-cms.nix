{
  config,
  pkgs,
  lib,
  self,
  ...
}:
let
  cfg = config.services.ghost-cms;
in
{
  options = {
    services.ghost-cms = {
      enable = lib.mkEnableOption "ghost, open source blog & newsletter platform";

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Path to an environment file to source before starting the service";
      };

      package = lib.mkPackageOption self.packages.${pkgs.stdenv.hostPlatform.system} "ghost-cms" { };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.ghost-cms = {
      isSystemUser = true;
      group = "ghost-cms";
    };
    users.groups.ghost-cms = { };

    systemd = {
      services.ghost-cms = {
        description = "ghost - open source blog & newsletter platform";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          DynamicUser = false;
          User = "ghost-cms";
          Group = "ghost-cms";
          WorkingDirectory = "/var/lib/ghost-cms";
          StateDirectory = "ghost-cms";
          StateDirectoryMode = "0750";

          ExecStart = "${cfg.package}/bin/ghost";
          Restart = "on-failure";

          Environment = [
            "NODE_ENV=production"

            # local only for security
            "server__host=127.0.0.1"

            # point to stateDir
            "paths__contentPath=/var/lib/ghost-cms/content"

            # logging via journald
            "logging__transports='[\"stdout\"]'"
          ];
          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;

          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = [ "/var/lib/ghost-cms" ];
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;

          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
        };
      };
    };
  };
}
