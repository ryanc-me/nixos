{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-home.services.habitsync;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  imports = [ ./habitsync.nix ];

  options.mine.server-home.services.habitsync = {
    enable = mkEnableOption "habitsync (task management server)";
  };

  config = mkIf cfg.enable {
    sops.secrets."habitsync" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/habitsync.env;
      key = "";
    };

    services.habitsync = {
      enable = true;
      environmentFile = config.sops.secrets."habitsync".path;
    };

    services.nginx.virtualHosts."habitsync.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../../secrets/oauth2-proxy/snippets/main.conf};
      '';

      locations."/" = {
        proxyPass = "http://localhost:6842";
        extraConfig = ''
          include ${../../../server-nginx/services/oauth2-proxy/snippets/location.conf};
        '';
      };
      locations."/manifest.json" = {
        proxyPass = "http://localhost:6842/manifest.json";
        # set the correct content type
        extraConfig = ''
          default_type application/json;
        '';
      };
    };
  };
}
