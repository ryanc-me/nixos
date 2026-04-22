{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-home.services.fluidd;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-home.services.fluidd = {
    enable = mkEnableOption "fluidd (Voron)";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."fluidd.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../server-auth/services/authentik/nginx-snippets/server-block.conf};

        # for large gcode uploads
        client_max_body_size 250m;
      '';

      locations."/" = {
        proxyPass = "http://10.1.1.110:80";
        proxyWebsockets = true;
        extraConfig = ''
          include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        '';
      };
      locations."/sw.js" = {
        return = "404";
      };

      locations."/webcam-1/" = {
        proxyPass = "http://10.1.1.110";
        extraConfig = ''
          proxy_http_version 1.1;
          proxy_buffering off;
          proxy_request_buffering off;
          proxy_read_timeout 1d;
          proxy_send_timeout 1d;
          send_timeout 1d;
        '';
      };
    };
  };
}
