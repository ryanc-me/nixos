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
    services.rutorrent = {
      enable = true;
      dataDir = "/var/lib/rutorrent";
      nginx.enable = true;
      hostName = "rutorrent.${config.mine.server-media.domainBase}";
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

    services.nginx.virtualHosts."rutorrent.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../../secrets/oauth2-proxy/snippets/main.conf};
      '';

      locations."/".extraConfig = ''
        include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
      '';
    };
  };
}
