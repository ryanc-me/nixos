{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.server-nginx.services.certs;
  nginx = config.mine.server-nginx.services.nginx;
  certs = config.mine.server-nginx.services.certs;
in
{
  options.mine.server-nginx.domains.mixeto-io = {
    enable = mkEnableOption "mixeto.io domain";
  };

  config = mkIf cfg.enable {
    security.acme = mkIf certs.enable {
      acceptTerms = true;
      defaults.email = "admin+acme@ryanc.me";

      certs."mixeto.io" = {
        domain = "mixeto.io";
        extraDomainNames = [ "*.mixeto.io" ];
        dnsProvider = "cloudflare";
        dnsPropagationCheck = true;
        environmentFile = config.sops.secrets."cloudflare-api-token".path;
        group = config.services.nginx.group;

        reloadServices = mkIf nginx.enable [
          "nginx"
        ];
      };
    };
    services.nginx.virtualHosts = mkIf nginx.enable {
      "mixeto.io" = {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null;
        locations."/".return = "307 https://www.mixeto.io";
      };
      "www.mixeto.io" = {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null;
        locations."/".return = "307 https://www.ryanc.me";
      };
      "auth.mixeto.io" = {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null;
        locations."= /".return = "307 https://www.mixeto.io";

        locations."/oauth2/" = {
          proxyPass = "http://127.0.0.1:4180";
        };
        locations."~ \"^/redirect/(?<r_host>(?:[A-Za-z0-9-]+\\.)*(?:ryanc\\.me|mixeto\\.io))(?<r_path>/[A-Za-z0-9\\-._~!$&'()*+,;=:@/%]*)?$\"" =
          {
            extraConfig = ''
              if ($request_uri ~* "(%0d|%0a|\\r|\\n)") { return 400; }
              if ($args       ~* "(%0d|%0a|\\r|\\n)") { return 400; }
              set $safe_path $r_path;
              if ($safe_path = "") { set $safe_path "/"; }

              return 307 https://$r_host$safe_path$is_args$args;
            '';
          };
      };
    };
  };
}
