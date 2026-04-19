{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-home.services.mealie;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-home.services.mealie = {
    enable = mkEnableOption "mealie (recipe/meal management)";
  };

  config = mkIf cfg.enable {
    sops.secrets."mealie" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/mealie.env;
      key = "";
    };

    services.mealie = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9020;
      settings = {
        DB_ENGINE = "postgres";
        POSTGRES_URL_OVERRIDE = "postgresql:///mealie?host=/run/postgresql";
      };
      credentialsFile = config.sops.secrets."habitsync".path;
    };

    services.postgresql = {
      enable = true;

      ensureDatabases = [ "mealie" ];
      ensureUsers = [
        {
          name = "mealie";
          ensureDBOwnership = true;
        }
      ];
    };

    services.nginx.virtualHosts."mealie.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../server-auth/services/authentik/nginx-snippets/server-block.conf};
      '';

      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.mealie.port}";
        extraConfig = ''
          include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        '';
      };
    };
  };
}
