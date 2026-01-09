{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.lidarr;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-media.services.lidarr = {
    enable = mkEnableOption "lidarr (subtitle manager)";
  };

  config = mkIf cfg.enable {
    services.lidarr = {
      enable = true;
      dataDir = "/var/lib/lidarr";
    };
    users.users."lidarr".extraGroups = [ "media-music" "torrent-data" "usenet-data" ];

    services.nginx.virtualHosts."lidarr.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
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
        proxyPass = "http://localhost:${toString config.services.lidarr.settings.server.port}";
        extraConfig = ''
          include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
        '';
      };
    };
  };
}
