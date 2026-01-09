{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-immich.services.immich;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-immich.services.immich = {
    enable = mkEnableOption "immich service";
  };

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
      host = "127.0.0.1";
      mediaLocation = "/mnt/raid-data/immich/uploads";
      database = {
        enableVectors = false;
      };
      settings = {
        server = {
          externalDomain = "https://immich.${config.mine.server-nginx.domainBase}";
        };
      };
    };

    services.nginx = {
      virtualHosts."immich.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null; # because we're using DNS-01
        http2 = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
      };
    };
  };
}
