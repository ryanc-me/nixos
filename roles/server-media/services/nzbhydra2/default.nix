{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-media.services.nzbhydra2;
  nginx = config.mine.server-media.services.nginx;
in
{
  options.mine.server-media.services.nzbhydra2 = {
    enable = mkEnableOption "nzbhydra2 (indexer aggregator)";
  };

  config = mkIf cfg.enable {
    services.nzbhydra2 = {
      enable = true;
    };

    services.nginx.virtualHosts."nzbhydra2.${config.mine.server-media.domainBase}" = mkIf nginx.enable {
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
        proxyPass = "http://localhost:5076";
        extraConfig = ''
          include ${../oauth2-proxy/snippets/location.conf};
        '';
      };
    };
  };
}
