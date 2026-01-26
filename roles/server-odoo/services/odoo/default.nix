{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-odoo.services.odoo;
  nginx = config.mine.server-nginx.services.nginx;

  odooPkg = self.packages.${pkgs.stdenv.hostPlatform.system}.odoo;
  odooConf = ../../../../secrets/odoo.conf;
in
{
  options.mine.server-odoo.services.odoo = {
    enable = mkEnableOption "odoo service";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      odooPkg
    ];
    users.groups.odoo = { };
    users.users.odoo = {
      isSystemUser = true;
      group = "odoo";
      home = "/var/lib/odoo";
      createHome = true;
    };

    systemd = {
      services.odoo = {
        description = "odoo - open source ERP and CRM";
        after = [
          "network.target"
          "postgresql.target"
        ];
        wantedBy = [ "multi-user.target" ];
        requires = [ "postgresql.target" ];
        serviceConfig = {
          Type = "simple";
          User = "odoo";
          Group = "odoo";
          # DynamicUser = true;
          StateDirectory = "odoo";
          ExecStart = "${odooPkg}/bin/odoo --config ${odooConf}";
          Restart = "on-failure";
        };
      };
    };

    services.postgresql = {
      enable = true;

      ensureDatabases = [ "odoo" ];
      ensureUsers = [
        {
          name = "odoo";
          ensureDBOwnership = true;
        }
      ];
      authentication = ''
        #type database  DBuser  auth-method
        local postgres  odoo    peer
      '';
    };

    services.nginx = {
      virtualHosts."odoo.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null; # because we're using DNS-01
        http2 = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8069";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        locations."/websocket" = {
          proxyPass = "http://127.0.0.1:8072";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        locations."/website/info" = {
          return = "302 /";
        };
      };
    };
  };
}
