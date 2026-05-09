{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-home.services.vikunja;
  nginx = config.mine.server-nginx.services.nginx;
in
{
  options.mine.server-home.services.vikunja = {
    enable = mkEnableOption "vikunja (task management server)";
  };

  config = mkIf cfg.enable {
    sops.secrets."vikunja" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/vikunja.env;
      key = "";
    };

    services.vikunja = {
      enable = true;
      frontendScheme = "https";
      frontendHostname = "vikunja.${config.mine.server-nginx.domainBase}";
      environmentFiles = [
        config.sops.secrets."vikunja".path
      ];
      settings = {
        auth = {
          local = {
            enabled = true;
          };
          openid = {
            enabled = true;
            providers.authentik = {
              name = "Authentik";
              authurl = "https://auth.mixeto.io/application/o/vikunja-oidc/";
              scope = "openid profile email";
              usernamefallback = true;
              emailfallback = true;
            };
          };
        };
      };
    };

    services.nginx.virtualHosts."vikunja.${config.mine.server-nginx.domainBase}" = mkIf nginx.enable {
      forceSSL = true;
      useACMEHost = "mixeto.io";
      acmeRoot = null; # because we're using DNS-01
      http2 = true;

      extraConfig = ''
        include ${../../../server-nginx/services/nginx/snippets/ocsp-stapling.conf};
        include ${../../../server-nginx/services/nginx/snippets/ssl-secure.conf};
        include ${../../../server-auth/services/authentik/nginx-snippets/server-block.conf};
      '';

      locations."/" = {
        proxyPass = "http://localhost:${toString config.services.vikunja.port}";
        extraConfig = ''
          include ${../../../server-auth/services/authentik/nginx-snippets/location-block.conf};
        '';
      };
    };
    mine.server-auth.services.authentik.proxyApplications.vikunja = {
      namePretty = "Vikunja";
      group = "Home";
      assignedGroups = [ "user-home" ];
    };
    mine.server-auth.services.authentik.outpostExtraProviders = [
      {
        model = "oauth2";
        name = "Vikunja (OIDC)";
      }
    ];
  };
}
