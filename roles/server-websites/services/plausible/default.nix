{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-websites.services.plausible;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-websites.services.plausible = {
    enable = mkEnableOption "websites service";
  };

  config = mkIf cfg.enable {
    sops.secrets."plausibleSecretKeybase" = {
      format = "yaml";
      sopsFile = ../../../../secrets/plausible.yaml;
      key = "secretKeybase";
    };

    services.plausible = {
      enable = true;

      server = {
        baseUrl = "https://stats.ryanc.me";
        secretKeybaseFile = config.sops.secrets."plausibleSecretKeybase".path;
      };
      database.postgres = {
        setup = false;
      };
    };
    services.postgresql = {
      enable = true;

      ensureDatabases = [ "plausible" ];
      ensureUsers = [
        {
          name = "plausible";
          ensureDBOwnership = true;
        }
      ];
    };

    services.nginx.virtualHosts."stats.ryanc.me" = {
      forceSSL = true;
      useACMEHost = "ryanc.me";
      acmeRoot = null;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        # include ${../../../../secrets/oauth2-proxy/snippets/main.conf};
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.plausible.server.port}";
        proxyWebsockets = true;
        extraConfig = ''
          # include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
        '';
      };
    };
  };
}
