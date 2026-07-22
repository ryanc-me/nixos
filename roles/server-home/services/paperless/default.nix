{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-home.services.paperless;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-home.services.paperless = {
    enable = mkEnableOption "paperless";
  };

  config = mkIf cfg.enable {
    sops.secrets."paperless" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/paperless.env;
      key = "";
    };

    services.paperless = {
      enable = true;

      mediaDir = "/mnt/torrent-data/paperless/media";
      domain = "paperless.${config.mine.server-nginx.domainBase}";
      environmentFile = config.sops.secrets."paperless".path;
      configureNginx = true;
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "paperless" ];
      ensureUsers = [
        {
          name = "paperless";
          ensureDBOwnership = true;
        }
      ];
    };

    services.nginx.virtualHosts."paperless.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../server-auth/services/authentik/nginx-snippets/server-block.conf};

        # for large gcode uploads
        client_max_body_size 250m;
      '';

      locations."/" = {
        extraConfig = ''
          include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        '';
      };
      locations."/static/" = {
        extraConfig = ''
          include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        '';
      };
      locations."/ws/status" = {
        extraConfig = ''
          include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        '';
      };
    };

    mine.server-auth.services.authentik.proxyApplications.paperless = {
      namePretty = "paperless";
      group = "Admin";
      assignedGroups = [ "admin" ];
    };
  };
}
