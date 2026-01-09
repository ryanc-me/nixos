{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.sonarr;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-media.services.sonarr = {
    enable = mkEnableOption "Sonarr (TV shows)";
  };

  config = mkIf cfg.enable {
    services.sonarr = {
      enable = true;
      dataDir = "/var/lib/sonarr";
    };

    users.users."sonarr".extraGroups = [ "media-tv" "torrent-data" "usenet-data" ];

    services.nginx.virtualHosts."sonarr.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
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
        proxyPass = "http://127.0.0.1:${toString config.services.sonarr.settings.server.port}";
        extraConfig = ''
          include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
        '';
      };
    };
  };
}
