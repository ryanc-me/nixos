{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-immich.services.immich-public-proxy;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-immich.services.immich-public-proxy = {
    enable = mkEnableOption "immich public proxy service";
  };

  config = mkIf cfg.enable {
    services.immich-public-proxy = {
      enable = true;
      immichUrl = "http://127.0.0.1:${toString config.services.immich.port}";
    };

    services.nginx = {
      virtualHosts."immich.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
        locations."/share/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.immich-public-proxy.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
        locations."/s/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.immich-public-proxy.port}";
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
