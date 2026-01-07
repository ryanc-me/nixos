{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-matrix.services.continuwuity;
  nginx = config.mine.server-nginx.services.nginx;

  wellKnownConfig = ''
    default_type application/json;
    add_header Access-Control-Allow-Origin "*";
    add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS";
    add_header Access-Control-Allow-Headers "X-Requested-With, Content-Type, Authorization";
  '';
in
{
  options.mine.server-matrix.services.continuwuity = {
    enable = mkEnableOption "continuwuity service";
  };

  config = mkIf cfg.enable {
    services.matrix-continuwuity = {
      enable = true;

      settings = {
        global = {
          server_name = "mixeto.io";
          address = [ "127.0.0.1" ];
        };
      };
    };

    services.nginx = {
      virtualHosts."matrix.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null; # because we're using DNS-01
        http2 = true;

        locations."/_matrix/" = {
          proxyPass = "http://127.0.0.1:6167";
          proxyWebsockets = true;
        };
      };

      virtualHosts."${config.mine.server-nginx.domainBase}" = {
        locations."/.well-known/matrix/server" = {
          return = "200 '{\"m.server\": \"matrix.mixeto.io:443\"}'";
          extraConfig = wellKnownConfig;
        };
        locations."/.well-known/matrix/client" = {
          return = "200 '{\"m.homeserver\": {\"base_url\": \"https://matrix.mixeto.io\"}}'";
          extraConfig = wellKnownConfig;
        };
        locations."/.well-known/matrix/support" = {
          return = "404";
          extraConfig = wellKnownConfig;
        };
      };
    };
  };
}
