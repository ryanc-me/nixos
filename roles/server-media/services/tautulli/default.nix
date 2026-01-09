{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.tautulli;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-media.services.tautulli = {
    enable = mkEnableOption "tautulli (TV shows)";
  };

  config = mkIf cfg.enable {
    services.tautulli = {
      enable = true;
      dataDir = "/var/lib/tautulli";
      configFile = "/var/lib/tautulli/config.ini";
      user = "tautulli";
      group = "tautulli";
    };
    users = {
      users."tautulli" = {
        group = "tautulli";
        uid = config.ids.uids.plexpy; # plexpy was the old name
      };
      groups."tautulli" = {};
    };

    services.nginx.virtualHosts."tautulli.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
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
        proxyPass = "http://localhost:${toString config.services.tautulli.port}";
        extraConfig = ''
          include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
        '';
      };
    };
  };
}
