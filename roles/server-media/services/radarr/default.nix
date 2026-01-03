{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.radarr;
  nginx = config.mine.server-media.services.nginx;
in
{
  options.mine.server-media.services.radarr = {
    enable = mkEnableOption "Radarr (movies)";
  };

  config = mkIf cfg.enable {
    services.radarr = {
      enable = true;
    };

    services.nginx.virtualHosts."radarr.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../nginx/snippets/ocsp-stapling.conf};
        include ${../nginx/snippets/ssl-secure.conf};
      '';

      locations."/" = {
        proxyPass = "http://localhost:7878";
      };
    };
  };
}
