{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.rutorrent;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-media.services.rutorrent = {
    enable = mkEnableOption "rutorrent (TV shows)";
  };

  config = mkIf cfg.enable {
    # mine.server-auth.services.authentik.blueprints.rutorrent = rutorrentBlueprint;
    services.rutorrent = {
      enable = true;
      dataDir = "/var/lib/rutorrent";
      nginx.enable = true;
      hostName = "rutorrent.${config.mine.server-nginx.domainBase}";
      plugins = [
        "_getdir"
        "_noty"
        "_noty2"
        "_task"
        "check_port"
        "chunks"
        "data"
        "datadir"
        "diskspace"
        "erasedata"
        "geoip"
        "history"
        "httprpc"
        "ratio"
        "scheduler"
        "seedingtime"
        "source"
        "unpack"
      ];
    };

    systemd.services.rtorrent.serviceConfig.SupplementaryGroups = [ config.services.rtorrent.group ];

    services.nginx.virtualHosts."rutorrent.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../server-auth/services/authentik/nginx-snippets/server-block.conf};
      '';

      locations."/".extraConfig = ''
        include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
      '';
    };
    mine.server-auth.services.authentik.proxyApplications.rutorrent = {
      namePretty = "ruTorrent";
    };
  };
}
