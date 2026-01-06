{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.radarr;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-media.services.radarr = {
    enable = mkEnableOption "Radarr (movies)";
  };

  config = mkIf cfg.enable {
    services.radarr = {
      enable = true;
      dataDir = "/var/lib/radarr";
    };
    users.users."radarr".extraGroups = [ "media-movies" "torrent-data" "usenet-data" ];

    services.nginx.virtualHosts."radarr.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
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
        proxyPass = "http://localhost:7878";
        extraConfig = ''
          include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
        '';
      };
    };
  };
}
