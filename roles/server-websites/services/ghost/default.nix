{
  config,
  pkgs,
  lib,
  self,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-websites.services.ghost;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  imports = [ ./ghost-cms.nix ];

  options.mine.server-websites.services.ghost = {
    enable = mkEnableOption "websites service";
  };

  config = mkIf cfg.enable {
    sops.secrets."ghost-cms" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/ghost-cms.env;
      key = "";
    };

    services.ghost-cms = {
      enable = true;
      environmentFile = config.sops.secrets."ghost-cms".path;
    };

    services.nginx.virtualHosts."ghost.ryanc.me" = {
      forceSSL = true;
      useACMEHost = "ryanc.me";
      acmeRoot = null;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
      '';

      # port 2368
      locations."/" = {
        proxyPass = "http://localhost:2368";
      };
      locations."=/" = {
        return = "302 /ghost";
      };
    };
  };
}
