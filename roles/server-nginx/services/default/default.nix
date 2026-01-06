{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-nginx.services.default;
in
{
  options.mine.server-nginx.services.default = {
    enable = mkEnableOption "default Nginx vhost";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."default" = mkIf cfg.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;
      default = true;

      extraConfig = ''
        include ${../nginx/snippets/ocsp-stapling.conf};
        include ${../nginx/snippets/ssl-secure.conf};
      '';

      locations."/".return = "404";
    };
  };
}
