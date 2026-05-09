{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.seerr;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-media.services.seerr = {
    enable = mkEnableOption "seerr (request management)";
  };

  config = mkIf cfg.enable {
    services.seerr = {
      enable = true;
    };

    services.nginx.virtualHosts."overseerr.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      locations."/" = {
        return = 301 "https://seerr.${config.mine.server-nginx.domainBase}$request_uri";
      };
    };

    services.nginx.virtualHosts."seerr.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
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
        proxyPass = "http://localhost:${toString config.services.seerr.port}";
        extraConfig = ''
          include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        '';
      };
    };
    mine.server-auth.services.authentik.proxyApplications.seerr = {
      namePretty = "Seerr";
      group = "Media";
      assignedGroups = [ "user-media" ];
    };
  };
}
