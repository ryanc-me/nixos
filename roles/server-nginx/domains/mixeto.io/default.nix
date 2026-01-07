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
        locations."/".return = "404";
      };
      "www.mixeto.io" = {
        forceSSL = true;
        useACMEHost = "mixeto.io";
        acmeRoot = null;
        locations."/".return = "404";
      };
    };
  };
}
