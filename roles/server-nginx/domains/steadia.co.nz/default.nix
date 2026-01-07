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
  options.mine.server-nginx.domains.steadia-co-nz = {
    enable = mkEnableOption "steadia.co.nz domain";
  };
  
  config = mkIf cfg.enable {
    security.acme = mkIf certs.enable {
      acceptTerms = true;
      defaults.email = "admin+acme@ryanc.me";

      certs."steadia.co.nz" = {
        domain = "steadia.co.nz";
        extraDomainNames = [ "*.steadia.co.nz" ];
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
      "steadia.co.nz" = {
        forceSSL = true;
        useACMEHost = "steadia.co.nz";
        acmeRoot = null;
        locations."/".return = "302 'https://www.linkedin.com/in/angel-storey/'";
        # locations."/".return = "404";
      };
      "www.steadia.co.nz" = {
        forceSSL = true;
        useACMEHost = "steadia.co.nz";
        acmeRoot = null;
        locations."/".return = "302 'https://www.linkedin.com/in/angel-storey/'";
        # locations."/".return = "404";
      };
    };
  };
}
