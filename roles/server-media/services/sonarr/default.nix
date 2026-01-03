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
    };

    services.nginx.virtualHosts."sonarr.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../nginx/snippets/ocsp-stapling.conf};
        include ${../nginx/snippets/ssl-secure.conf};
      '';

      locations."/" = {
        proxyPass = "http://localhost:8989";
      };
    };
  };
}
