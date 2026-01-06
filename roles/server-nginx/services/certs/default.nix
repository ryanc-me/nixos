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
in
{
  options.mine.server-nginx.services.certs = {
    enable = mkEnableOption "certs for mixeto.io";
  };

  config = mkIf cfg.enable {
    sops.secrets."cloudflare-api-token" = {
      format = "dotenv";
      sopsFile = ../../../../secrets/acme-cloudflare.env;
      key = "";
    };

    security.acme = {
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
  };
}
