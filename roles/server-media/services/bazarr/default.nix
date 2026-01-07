{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.bazarr;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-media.services.bazarr = {
    enable = mkEnableOption "Bazarr (subtitle manager)";
  };

  config = mkIf cfg.enable {
    services.bazarr = {
      enable = true;
      dataDir = "/var/lib/bazarr";
    };

    services.nginx.virtualHosts."bazarr.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../../secrets/oauth2-proxy/snippets/main.conf};
      '';

      locations."/" = {
        proxyPass = "http://localhost:6767";
        extraConfig = ''
          include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
        '';
      };
    };
  };
}
