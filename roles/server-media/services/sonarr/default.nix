{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.sonarr;
  nginx = config.mine.server-media.services.nginx;
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

    users.users."sonarr".extraGroups = [ "media-tv" ];

    services.nginx.virtualHosts."sonarr.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../nginx/snippets/ocsp-stapling.conf};
        include ${../nginx/snippets/ssl-secure.conf};
        include ${../oauth2-proxy/snippets/main.conf};
      '';

      locations."/" = {
        proxyPass = "http://localhost:8989";
        extraConfig = ''
          include ${../oauth2-proxy/snippets/location.conf};
        '';
      };
    };
  };
}
