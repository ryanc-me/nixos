{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-nginx.services.nginx = {
    enable = mkEnableOption "Nginx";
  };

  config = mkIf cfg.enable {
    security.dhparams = {
      enable = true;
      params."nginx".bits = 3072;
    };
    services.nginx = {
      enable = true;

      sslDhparam = config.security.dhparams.params."nginx".path;

      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;

      # default vhost for non-matched domains
      # note that this only really works for mixeto.io due to the certs
      virtualHosts."default" = {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null;
        http2 = true;
        default = true;

        extraConfig = ''
          include ${./snippets/ocsp-stapling.conf};
          include ${./snippets/ssl-secure.conf};
        '';

        locations."/".return = "404";
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
