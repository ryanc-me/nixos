{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-auth.services.authentik;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-auth.services.authentik = {
    enable = mkEnableOption "authentik service";
  };

  config = mkIf cfg.enable {

    sops.secrets."authentik-env" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/authentik.env;
    };

    services.authentik = {
      enable = true;

      environmentFile = config.sops.secrets."authentik-env".path;

      nginx.enable = false; # we'll do it ourselves
      settings = {
        cookie_domain = config.mine.server-nginx.domainBase;
        listen = {
          http = "127.0.0.1:5080";
          https = "127.0.0.1:5443";
        };
      };
    };
    # services.authentik-proxy = {
    #   enable = true;
    # };

    services.nginx = {
      virtualHosts."auth.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null; # because we're using DNS-01
        http2 = true;

        locations."/" = {
          proxyPass = "https://127.0.0.1:5443";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
  };
}
