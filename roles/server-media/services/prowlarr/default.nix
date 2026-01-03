{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.prowlarr;
  nginx = config.mine.server-media.services.nginx;
in
{
  options.mine.server-media.services.prowlarr = {
    enable = mkEnableOption "Prowlarr (indexer aggregator)";
  };

  config = mkIf cfg.enable {
    services.prowlarr = {
      enable = true;
    };

    services.nginx.virtualHosts."prowlarr.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../nginx/snippets/ocsp-stapling.conf};
        include ${../nginx/snippets/ssl-secure.conf};
      '';

      locations."/" = {
        proxyPass = "http://localhost:9696";
      };
    };
  };
}
