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
  options.mine.server-nginx.domains.ryanc-me = {
    enable = mkEnableOption "ryanc.me domain";
  };

  config = mkIf cfg.enable {
    security.acme = mkIf certs.enable {
      acceptTerms = true;
      defaults.email = "admin+acme@ryanc.me";

      certs."ryanc.me" = {
        domain = "ryanc.me";
        extraDomainNames = [ "*.ryanc.me" ];
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
      "ryanc.me" = {
        forceSSL = true;
        useACMEHost = "ryanc.me";
        acmeRoot = null;
      };
      "www.ryanc.me" = {
        forceSSL = true;
        useACMEHost = "ryanc.me";
        acmeRoot = null;
      };
    };
  };
}
