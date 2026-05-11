{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.qbittorrent;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-media.services.qbittorrent = {
    enable = mkEnableOption "qBittorrent (torrent client)";
  };

  config = mkIf cfg.enable {
    services.qbittorrent = {
      enable = true;
      webuiPort = 8085;
      torrentingPort = 40032;
    };
    users.users."qbittorrent".extraGroups = [
      "torrent-data"
      "media-tv"
      "media-movies"
      "media-music"
    ];

    networking.firewall = {
      allowedTCPPorts = [ config.services.qbittorrent.torrentingPort ];
      allowedUDPPorts = [ config.services.qbittorrent.torrentingPort ];
    };

    services.nginx.virtualHosts."qbittorrent.${config.mine.server-nginx.domainBase}" =
      mkIf nginx.enable
        {
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
            proxyPass = "http://localhost:${toString config.services.qbittorrent.webuiPort}";
            extraConfig = ''
              include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
            '';
          };
        };
    mine.server-auth.services.authentik.proxyApplications.qbittorrent = {
      namePretty = "qBittorrent";
      group = "Media";
      assignedGroups = [ "admin" ];
    };
  };
}
